/* The SPIMbot software is derived from James Larus's SPIM.  Modifications
    to SPIM are covered by the following license:

 Copyright © 2012, University of Illinois.  All rights reserved.

 Developed by:  Craig Zilles
                Department of Computer Science
                     University of Illinois at Urbana-Champaign
                     http://www-faculty.cs.uiuc.edu/~zilles/spimbot

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal with the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:

 Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimers.

 Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimers in the
 documentation and/or other materials provided with the distribution.

 Neither the name of the University of Illinois nor the names of its
 contributors may be used to endorse or promote products derived from
 this Software without specific prior written permission.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT.  IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
 IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE
 SOFTWARE. */

#ifdef SCENARIO_HEADER

#define MATRIX_HEADER
#include "../Puzzle/matrix.c"
#undef MATRIX_HEADER

typedef struct apple_t {
    float x, y;
    unsigned color;
    apple_t* next;
} apple_t;

typedef struct {

    int apples_collected;
    int query_apple;

    bool good_solution;

    bool private_apple_created;
    bool apple_eaten;

    int private_apple_x;
    int private_apple_y;
    int eaten_apple_x;
    int eaten_apple_y;

    int PRIVATE_APPLE_RELOCATE_COUNTER;
    int PRIVATE_APPLE_CREATION_COUNTER;

    int puzzle_index;
    bool puzzle_requested;
    int requested_minus_correct;

} scenario_bot_state_t;

#define SPIMBOT_PRIVATE_APPLE_CREATED_ACK ((mem_addr) 0xffff0064)
#define SPIMBOT_APPLE_EATEN_ACK ((mem_addr) 0xffff0068)

#define SPIMBOT_QUERY_PUBLIC_APPLE ((mem_addr) 0xffff0078)
#define SPIMBOT_PUBLIC_APPLE_X ((mem_addr) 0xffff0070)
#define SPIMBOT_PUBLIC_APPLE_Y ((mem_addr) 0xffff0074)
#define SPIMBOT_PRIVATE_APPLE_X ((mem_addr) 0xffff00b0)
#define SPIMBOT_PRIVATE_APPLE_Y ((mem_addr) 0xffff00b4)
#define SPIMBOT_EATEN_APPLE_X ((mem_addr) 0xffff00b8)
#define SPIMBOT_EATEN_APPLE_Y ((mem_addr) 0xffff00bc)

#define SPIMBOT_REQUEST_PUZZLE ((mem_addr) 0xffff0090)
#define SPIMBOT_SUBMIT_PUZZLE ((mem_addr) 0xffff0094)

#define SB_PRIVATE_APPLE_CREATED_INT_MASK 0x2000
#define SB_APPLE_EATEN_INT_MASK 0x4000

#else /* ! SCENARIO_HEADER */

#include "../Puzzle/matrix.c"

#ifdef _WIN32
#define srandom srand
#define srand48 srand
#define lrand48 rand
#endif

int draw_text = 1;

#ifndef min
#define min(x,y) (((x)<(y)) ? (x) : (y))
#endif
#ifndef max
#define max(x,y) (((x)>(y)) ? (x) : (y))
#endif

const int APPLE_RADIUS = 3;
const int NUM_PUBLIC_APPLES = 1;
const int PRIVATE_APPLE_RELOCATE_CYCLE = 100;
const int PRIVATE_APPLE_CREATION_DELAY = 1000;
const double PRIVATE_APPLE_CREATION_DELAY_PENALTY_BASE = 1.1;

apple_t public_apples[NUM_PUBLIC_APPLES];
apple_t* private_apples; // there is a sentinel !!!

HexList** puzzles;
int puzzles_count;
int puzzles_size;

int public_apples_init_x[NUM_PUBLIC_APPLES] = {40};
int public_apples_init_y[NUM_PUBLIC_APPLES] = {100};



void
apple_initialize() {
    for (int i = 0 ; i < NUM_PUBLIC_APPLES / 2 ; ++ i) {
        public_apples[i].x = public_apples_init_x[i];
        public_apples[i].y = public_apples_init_x[i];
        public_apples[NUM_PUBLIC_APPLES - 1 - i].x = WORLD_SIZE - public_apples_init_x[i];
        public_apples[NUM_PUBLIC_APPLES - 1 - i].y = WORLD_SIZE - public_apples_init_x[i];

        if (spimbot_debug) {
            printf("a public apple is created at %d, %d\n",
                   (int) public_apples[i].x, (int) public_apples[i].y);
            printf("a public apple is created at %d, %d\n",
                   (int) public_apples[NUM_PUBLIC_APPLES - 1 - i].x, (int) public_apples[NUM_PUBLIC_APPLES - 1 - i].y);
            fflush(stdout);
        }
    }
    public_apples[NUM_PUBLIC_APPLES / 2].x = (float)WORLD_SIZE/2 + ((lrand48()&1) ? .001 : -.001);
    public_apples[NUM_PUBLIC_APPLES / 2].y = (float)WORLD_SIZE/2;

    if (spimbot_debug) {
        printf("a public apple is created at %d, %d\n",
               (int) public_apples[NUM_PUBLIC_APPLES / 2].x, (int) public_apples[NUM_PUBLIC_APPLES / 2].y);
        fflush(stdout);
    }

    private_apples = new apple_t;
    private_apples->next = NULL;
}

void 
bot_scenario_init(bot_state_t *bot) {
    bot->scenario.apples_collected = 0;
    bot->scenario.query_apple = 0;

    bot->scenario.private_apple_x = RANDOM_LOC;
    bot->scenario.private_apple_y = RANDOM_LOC;
    bot->scenario.eaten_apple_x = -1;
    bot->scenario.eaten_apple_y = -1;

    bot->scenario.good_solution = false;

    bot->scenario.private_apple_created = false;
    bot->scenario.apple_eaten = false;

    bot->scenario.PRIVATE_APPLE_RELOCATE_COUNTER = PRIVATE_APPLE_RELOCATE_CYCLE;

    bot->scenario.puzzle_index = -1;
    bot->scenario.puzzle_requested = false;

    bot->scenario.requested_minus_correct = 0;
}

void
world_initialize() {
    srandom(time(NULL));

    if (spimbot_randommap) {
        if (spimbot_randomseed == -1) {
            srand48(time(NULL));
        }
        else {
            srand48(spimbot_randomseed);
        }
    }
    else {
        srand48(0);
    }

    if (spimbot_largemap)
        drawing_scaling = 2.0;

    MapWindow->resize(SCALE(WORLD_SIZE), SCALE(WORLD_SIZE) + LABEL_SPACE);

    bot_initialize(0, /* random */ 0);
    bot_scenario_init(&robots[0]);

    bot_initialize(1, /* random */ 0);
    bot_scenario_init(&robots[1]);

    apple_initialize();

    puzzles = (HexList**) malloc(sizeof(HexList*));
    puzzles_count = 0;
    puzzles_size = 1;

    MapWindow->repaint();
}

bool
bot_motion_update_scenario(bot_state_t *bot) {

    if (bot->scenario.PRIVATE_APPLE_RELOCATE_COUNTER > 0) {
        -- bot->scenario.PRIVATE_APPLE_RELOCATE_COUNTER;
        if (bot->scenario.PRIVATE_APPLE_RELOCATE_COUNTER == 0) {
            bot->scenario.private_apple_x = RANDOM_LOC;
            bot->scenario.private_apple_y = RANDOM_LOC;
            bot->scenario.PRIVATE_APPLE_RELOCATE_COUNTER = PRIVATE_APPLE_RELOCATE_CYCLE;
        }
    }

    if (bot->scenario.PRIVATE_APPLE_CREATION_COUNTER > 0) {
        -- bot->scenario.PRIVATE_APPLE_CREATION_COUNTER;
        if (bot->scenario.PRIVATE_APPLE_CREATION_COUNTER == 0) {
            bot->scenario.private_apple_x = RANDOM_LOC;
            bot->scenario.private_apple_y = RANDOM_LOC;

            bot->scenario.private_apple_created = true;

            bot->scenario.PRIVATE_APPLE_RELOCATE_COUNTER = PRIVATE_APPLE_RELOCATE_CYCLE;

            if (bot->scenario.good_solution) {
                bot->scenario.good_solution = false;

                apple_t* apple = new apple_t;
                apple->x = bot->scenario.private_apple_x;
                apple->y = bot->scenario.private_apple_y;
                apple->color = bot->color;
                apple->next = private_apples->next;
                private_apples->next = apple;
                if (spimbot_debug) {
                    printf("bot %d created a private apple at %d, %d\n",  bot->context, (int) apple->x, (int) apple->y);
                    fflush(stdout);
                }
            }
        }
    }

    for (int i = 0 ; i < NUM_PUBLIC_APPLES ; ++ i) {
        if ((fabs(bot->snake->x() - public_apples[i].x) < (double) APPLE_RADIUS)
                && (fabs(bot->snake->y() - public_apples[i].y) < (double) APPLE_RADIUS)) {
            bot->scenario.apples_collected ++;
            bot->SNAKE_GROWTH_COUNTER += SNAKE_GROWTH_CYCLE;

            for (int j = 0; j < max_contexts; ++ j) {
                robots[j].scenario.apple_eaten = true;
                robots[j].scenario.eaten_apple_x = public_apples[i].x;
                robots[j].scenario.eaten_apple_y = public_apples[i].y;
            }

            if (spimbot_debug) {
                printf("bot %d eats an apple at %d, %d\n", bot->context, (int) public_apples[i].x, (int) public_apples[i].y);
                fflush(stdout);
            }

            public_apples[i].x = RANDOM_LOC;
            public_apples[i].y = RANDOM_LOC;

            if (spimbot_debug) {
                printf("a public apple is created at %d, %d\n", (int) public_apples[i].x, (int) public_apples[i].y);
                fflush(stdout);
            }
        }
    }

    if (private_apples != NULL) {
        apple_t* p = private_apples;
        while (p->next != NULL) {
            if ((fabs(bot->snake->x() - p->next->x) < (double) APPLE_RADIUS)
                    && (fabs(bot->snake->y() - p->next->y) < (double) APPLE_RADIUS)) {
                bot->scenario.apples_collected ++;
                bot->SNAKE_GROWTH_COUNTER += SNAKE_GROWTH_CYCLE;

                for (int j = 0; j < max_contexts; ++ j) {
                    if (robots[j].color == p->next->color) {
                        robots[j].scenario.apple_eaten = true;
                        robots[j].scenario.eaten_apple_x = p->next->x;
                        robots[j].scenario.eaten_apple_y = p->next->y;
                    }
                }

                if (spimbot_debug) {
                    printf("bot %d eats an apple at %d, %d\n", bot->context, (int) p->next->x, (int) p->next->y);
                    fflush(stdout);
                }

                apple_t* q = p->next->next;
                delete p->next;
                p->next = q;
            }
            else {
                p = p->next;
            }
        }
    }

    return false;
}

int
bot_io_update_scenario(bot_state_t *bot) {
    reg_image_t &reg_image = reg_images[bot->context];
    int cause = 0;

    if ((bot->scenario.private_apple_created)
            && INTERRUPTS_ON(reg_image)
            && (CP0_Status(reg_image) & SB_PRIVATE_APPLE_CREATED_INT_MASK)) {
        cause |= SB_PRIVATE_APPLE_CREATED_INT_MASK;
        if (!bot->done && spimbot_debug) {
            if (!spimbot_tournament) {
                printf("private apple created interrupt\n");
                fflush(stdout);
            }
        }
    }
    bot->scenario.private_apple_created = false;

    if ((bot->scenario.apple_eaten)
            && INTERRUPTS_ON(reg_image)
            && (CP0_Status(reg_image) & SB_APPLE_EATEN_INT_MASK)) {
        cause |= SB_APPLE_EATEN_INT_MASK;
        if (!bot->done && spimbot_debug) {
            if (!spimbot_tournament) {
                printf("apple eaten interrupt\n");
                fflush(stdout);
            }
        }
    }
    bot->scenario.apple_eaten = false;

    return cause;
}

int 
scenario_get_winner() {
    return robots[0].snake->snakeLength() < robots[1].snake->snakeLength();
}

void
scenario_map_init(QPainter* painter) {
}

void
draw_apples(QPainter* painter) {
    QPen pen(Qt::black);
    QBrush brush(Qt::SolidPattern);
    brush.setColor(Qt::green);

    painter->setPen(pen);
    painter->setBrush(brush);

    for (int i = 0 ; i < NUM_PUBLIC_APPLES ; ++ i) {
        painter->drawPie(SCALE(public_apples[i].x - APPLE_RADIUS), SCALE(public_apples[i].y - APPLE_RADIUS),
                         SCALE(2 * APPLE_RADIUS), SCALE(2 * APPLE_RADIUS), 16*90, 16*360);
    }

    if (private_apples != NULL) {
        apple_t* p = private_apples->next;
        while (p != NULL) {
            brush.setColor(p->color);
            painter->setBrush(brush);
            painter->drawPie(SCALE(p->x - APPLE_RADIUS), SCALE(p->y - APPLE_RADIUS),
                             SCALE(2 * APPLE_RADIUS), SCALE(2 * APPLE_RADIUS), 16*90, 16*360);
            p = p->next;
        }
    }
}

void
redraw_scenario(QPainter* painter) {
    draw_apples(painter);
}

void
scenario_set_bot_string(char *str, int i) {
    sprintf(str, "%d", (int) ((robots[i].snake != NULL) ? robots[i].snake->snakeLength() : 0));
}

int
scenario_write_spimbot_IO(int context, mem_addr addr, mem_word value) {
    bot_state_t *bot = &robots[context];
    switch (addr) {

    case SPIMBOT_PRIVATE_APPLE_CREATED_ACK:
        if (spimbot_grading) {
            printf("private apple interrupt acknowledged\n");
            fflush(stdout);
        }
        CP0_Cause(reg_images[bot->context]) &= ~SB_PRIVATE_APPLE_CREATED_INT_MASK;
        break;
    case SPIMBOT_APPLE_EATEN_ACK:
        if (spimbot_grading) {
            printf("apple eaten interrupt acknowledged\n");
            fflush(stdout);
        }
        CP0_Cause(reg_images[bot->context]) &= ~SB_APPLE_EATEN_INT_MASK;
        break;
    case SPIMBOT_QUERY_PUBLIC_APPLE:
        bot->scenario.query_apple = value;
        break;

    case SPIMBOT_REQUEST_PUZZLE: {
        ++ bot->scenario.puzzle_index;
        bot->scenario.puzzle_requested = true;
        ++ bot->scenario.requested_minus_correct;

        if (bot->scenario.puzzle_index >= puzzles_size) {
            puzzles = (HexList**) realloc(puzzles, sizeof(HexList*) * puzzles_size * 2);
            puzzles_size *= 2;
        }

        if (bot->scenario.puzzle_index >= puzzles_count) {
            HexMatrix* matrix = matrixGen(4);
            HexList* list = matrixToList(matrix);
            puzzles[puzzles_count] = list;
            ++ puzzles_count;

            free(matrix);
        }

        HexList* list = puzzles[bot->scenario.puzzle_index];
        mem_word mips_list = value;
        set_mem_word(bot->context, mips_list, list->size);
        mem_word mips_list_data = read_mem_word(bot->context, mips_list + 4);

        for (int i = 0; i < list->size; ++ i) {
            mem_word sub_array = read_mem_word(bot->context, mips_list_data + 4 * i);
            for (int j = 0; j < list->size / 2 ; ++ j) {
                set_mem_byte(bot->context, sub_array + j, list->data[i][j]);
            }
        }
        if (spimbot_debug) {
            printf("bot %d requested puzzle %d\n", bot->context, bot->scenario.puzzle_index);
            fflush(stdout);
        }

        break;
    }

    case SPIMBOT_SUBMIT_PUZZLE: {
        if (!bot->scenario.puzzle_requested) {
            if (spimbot_debug) {
                printf("you have to request a puzzle before submitting a solution\n");
                fflush(stdout);
            }
            break;
        }
        bot->scenario.puzzle_requested = false;

        mem_word mips_matrix = value;
        mem_word mips_matrix_size = read_mem_word(bot->context, mips_matrix);
        if (mips_matrix_size != puzzles[bot->scenario.puzzle_index]->size / 2) {
            bot->scenario.good_solution = false;
            if (spimbot_debug) {
                printf("the size of the submitted matrix is not matched with expected solution\n");
                printf("expected: %d\n", puzzles[bot->scenario.puzzle_index]->size / 2);
                printf("submitted: %d\n", mips_matrix_size);
                fflush(stdout);
            }
            break;
        }
        mem_word mips_matrix_data = read_mem_word(bot->context, mips_matrix + 4);

        HexMatrix* matrix = matrixMalloc(puzzles[bot->scenario.puzzle_index]->size / 2);
        for (int i = 0; i < mips_matrix_size; ++ i) {
            mem_word sub_array = read_mem_word(bot->context, mips_matrix_data + 4 * i);
            for (int j = 0; j < mips_matrix_size; ++ j) {
                matrix->data[i][j] = read_mem_byte(bot->context, sub_array + j);
            }
        }

        bot->scenario.PRIVATE_APPLE_CREATION_COUNTER
                = PRIVATE_APPLE_CREATION_DELAY
                * pow(PRIVATE_APPLE_CREATION_DELAY_PENALTY_BASE, bot->scenario.requested_minus_correct);

        if (verify(matrix, puzzles[bot->scenario.puzzle_index])) {
            -- bot->scenario.requested_minus_correct;
            bot->scenario.good_solution = true;
            if (spimbot_debug) {
                printf("the matrix submitted is correct\n");
                fflush(stdout);
            }
        }
        else {
            bot->scenario.good_solution = false;
            if (spimbot_debug) {
                printf("the matrix submitted is incorrect\n");
                printf("expected (or its transpose):\n");
                HexMatrix* sol = matrixMalloc(puzzles[bot->scenario.puzzle_index]->size / 2);
                solve(sol, puzzles[bot->scenario.puzzle_index], 0, 0);
                printMatrix(sol);
                free(sol);
                printf("submitted:\n");
                printMatrix(matrix);
                fflush(stdout);
            }
        }

        freeMatrix(matrix);
        break;
    }

    default:
        return 0;
    }
    return 1;
}

mem_word
scenario_read_spimbot_IO(int context, mem_addr addr, bool *success) {
    *success = 1;
    bot_state_t *bot = &robots[context];
    switch (addr) {

    case SPIMBOT_PUBLIC_APPLE_X: {
        mem_word x;
        if (bot->scenario.query_apple >= NUM_PUBLIC_APPLES) {
            x = (mem_word) public_apples[NUM_PUBLIC_APPLES - 1].x;
        } else {
            x = (mem_word) public_apples[bot->scenario.query_apple].x;
        }
        if (bot->context == 1 && reverse_image) {
            x = WORLD_SIZE - x;
        }
        return x;
    }
    case SPIMBOT_PUBLIC_APPLE_Y: {
        mem_word y;
        if (bot->scenario.query_apple >= NUM_PUBLIC_APPLES) {
            y = (mem_word)public_apples[NUM_PUBLIC_APPLES - 1].y;
        } else {
            y = (mem_word)public_apples[bot->scenario.query_apple].y;
        }
        if (bot->context == 1 && reverse_image) {
            y = WORLD_SIZE - y;
        }
        return y;
    }
    case SPIMBOT_PRIVATE_APPLE_X: {
        mem_word x = bot->scenario.private_apple_x;
        if (bot->context == 1 && reverse_image) {
            x = WORLD_SIZE - x;
        }
        return x;
    }
    case SPIMBOT_PRIVATE_APPLE_Y: {
        mem_word y = bot->scenario.private_apple_y;
        if (bot->context == 1 && reverse_image) {
            y = WORLD_SIZE - y;
        }
        return y;
    }
    case SPIMBOT_EATEN_APPLE_X: {
        mem_word x = bot->scenario.eaten_apple_x;
        if (bot->context == 1 && reverse_image) {
            x = WORLD_SIZE - x;
        }
        return x;
    }
    case SPIMBOT_EATEN_APPLE_Y: {
        mem_word y = bot->scenario.eaten_apple_y;
        if (bot->context == 1 && reverse_image) {
            y = WORLD_SIZE - y;
        }
        return y;
    }
    default:
        *success = 0;
        return 0;
    }
}

void
handle_wall_collisions_scenario(bot_state_t *bot, double delta_x, double delta_y) {
    // do nothing;
}

void scenario_world_update() {
    // do nothing
}

#endif /*  SCENARIO_HEADER */
