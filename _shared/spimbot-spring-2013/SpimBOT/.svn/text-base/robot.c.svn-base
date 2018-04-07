/* The SPIMbot software is derived from James Larus's SPIM.  Modifications
    to SPIM are covered by the following license:

 Copyright (c) 2004, University of Illinois.  All rights reserved.

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

#define __STDC_LIMIT_MACROS
#include <stdint.h>
#define SPIMBOT_MAXINT_32 INT32_MAX

#include <QPainter>

#include <assert.h>
#include <time.h>
#include <unistd.h>

#include "../CPU/spim.h"
#include "../CPU/string-stream.h"
#include "../CPU/inst.h"
#include "../CPU/reg.h"
#include "../CPU/mem.h"
#include "robot.h"
#include "spimbotview.h"

extern SpimbotView* MapWindow;

int spimbot_cycle_limit = 2000000;
bool spimbot_debug = false;
bool spimbot_exit_when_done = false;
bool spimbot_grading = false;
bool spimbot_largemap = false;
bool spimbot_maponly = false;
bool spimbot_randommap = false;
int spimbot_randomseed = -1;
bool spimbot_run = false;
bool spimbot_tournament = false;

// for scaling the map window
double drawing_scaling = 1.0;
#define SCALE(X) ((int) (drawing_scaling * (X)))

// to allow user to interrupt (FIXME: does this still do anything?)
bool map_click = false;
void spimbot_map_click() { map_click = true; }

// spimBOT world constants
const int WORLD_SIZE = 300;
const int LABEL_SPACE = 50;
const int BOT_RADIUS = 4; //SNAKE_HALF_WIDTH
const int BOT_POINTER_LENGTH = 10;
const double PI_DELTA = .001;
const double VELOCITY_SCALING_FACTOR = .00025;
const bool WALLS = true;

const int SNAKE_SHRINK_CYCLE = 10000;
const int SNAKE_GROWTH_CYCLE = 10000;

// contest related variables
bool reverse_image = false;
int cycle = 0;
bot_state_t robots[2];
Snake* snakes[2]; 

// test whether something happened recently
#define WINDOW 100
int withinWINDOW(int cycle1) { return ((cycle1 <= cycle) && ((cycle1 + WINDOW) >= cycle)); }

// get a random location or edge
#define RANDOM_LOC ((lrand48() % (WORLD_SIZE - 2*BOT_RADIUS)) + BOT_RADIUS)
#define RANDOM_EDGE ((lrand48() & 1) ? (WORLD_SIZE - BOT_RADIUS) : BOT_RADIUS)


#include "token_hunting.c"



void
bot_initialize(int context, bool randomize) {
    bot_state_t *bot = &(robots[context]);
    bot->context = context;
    bot->color = (context ? 0xff : 0xff0000);
    bot->done = false;
    bot->bonk = false;
    //bot->orientation = (context ? 180 : 0);
    bot->velocity = 10;
    bot->turn_value = 0;
    bot->timer = SPIMBOT_MAXINT_32;

    bot->snake = new Snake(context ? 200 : 100,
                           context ? 250 : 50,
                           context ? 250 : 50,
                           context ? 250 : 50,
                           context ? 180 : 0);

    bot->SNAKE_SHRINK_COUNTER = 0;
    bot->SNAKE_GROWTH_COUNTER = 0;

    snakes[context] = bot->snake;
}

void
handle_wall_collisions(bot_state_t *bot) {
    bot->bonk = true;
    bot->SNAKE_SHRINK_COUNTER += SNAKE_SHRINK_CYCLE;
    if (spimbot_debug) {
        printf("WALL BONK\n");
        fflush(stdout);
    }
}

void
handle_snake_collisions(bot_state_t *bot) {
    bot->bonk = true;
    bot->SNAKE_SHRINK_COUNTER += SNAKE_SHRINK_CYCLE;
    if (spimbot_debug) {
        printf("SNAKE BONK\n");
        fflush(stdout);
    }
}

void
bot_motion_update(bot_state_t *bot) {
    if (bot->done) {
        return;
    }

    double velocity = VELOCITY_SCALING_FACTOR * bot->velocity;
    
    if (bot->SNAKE_SHRINK_COUNTER > 0)
        -- bot->SNAKE_SHRINK_COUNTER;

    if (bot->SNAKE_GROWTH_COUNTER > 0)
        -- bot->SNAKE_GROWTH_COUNTER;

    bool moveHead = bot->SNAKE_SHRINK_COUNTER == 0;
    bool moveTail = bot->SNAKE_GROWTH_COUNTER == 0;

    int collision = bot->snake->moveSnake(velocity, moveHead, moveTail, &snakes[1 - bot->context], num_contexts - 1, 0, 0, WORLD_SIZE, WORLD_SIZE);
    if (bot->SNAKE_SHRINK_COUNTER == 0)
        if (collision == 1) {
            handle_wall_collisions(bot);
        }
    //distinguish between self and the other snake latter
        else if (collision == 2 || collision == 3) {
            handle_snake_collisions(bot);
        }

    // if (spimbot_debug && collision==2) printf("shrink: %i growth: %i collision: %i velocity: %f\n", bot->snake->SNAKE_SHRINK_COUNTER,bot->snake->SNAKE_GROWTH_COUNTER,collision,bot->velocity);
    bot_motion_update_scenario(bot);
}

void
bot_io_update(bot_state_t *bot) {
    reg_image_t &reg_image = reg_images[bot->context];
    int cause = 0;
    if (bot->bonk
            && INTERRUPTS_ON(reg_image)
            && (CP0_Status(reg_image) & SB_BONK_INT_MASK)
            && ((CP0_Cause(reg_image) & SB_BONK_INT_MASK) == 0)) {
        bot->bonk = false;
        cause |= SB_BONK_INT_MASK;
        if (!bot->done && spimbot_debug) {
            if (!spimbot_tournament) {
                printf("bonk interrupt\n");
                fflush(stdout);
            }
        }
    }

    if ((bot->timer < cycle)
            && INTERRUPTS_ON(reg_image)
            && (CP0_Status(reg_image) & SB_TIMER_INT_MASK)) {
        bot->timer = SPIMBOT_MAXINT_32;
        cause |= SB_TIMER_INT_MASK;
        if (!bot->done && spimbot_debug) {
            if (!spimbot_tournament) {
                //TODO
                //printf("timer interrupt\n");
                fflush(stdout);
            }
        }
    }

    // do scenario-specific stuff
    cause |= bot_io_update_scenario(bot);

    if (cause != 0) {
        if (spimbot_grading) {
            printf("raising an interrupt/exception; cause = %x\n", cause);
            fflush(stdout);
        }
        RAISE_EXCEPTION (reg_image, ExcCode_Int, CP0_Cause(reg_image) |= cause);
    }
}

void
bot_update(bot_state_t *bot) {
    bot_motion_update(bot);
    bot_io_update(bot);
}

int
world_update() {
    for (int i = 0 ; i < num_contexts ; ++ i) {
        // alternate which bot goes first for fairness
        int index = i ^ (cycle & (num_contexts-1));
        bot_update(&robots[index]);
    }

    scenario_world_update();

    ++ cycle;
    if ((cycle & 0xfff) == 0) {
        MapWindow->centralWidget()->repaint();
    }

    if ((cycle & 0xff) == 0) {
        usleep(1024);
    }

    /*if (map_click) {
        if (spimbot_tournament)
            map_click = false;
        else
            return 1;
    }*/

    if ((robots[0].done && ((num_contexts == 1) || robots[1].done)) ||
            (spimbot_cycle_limit && (cycle >= spimbot_cycle_limit))) {
        MapWindow->centralWidget()->repaint();
        int winner = scenario_get_winner();
        printf("cycles: %d\n", cycle);
        if (winner == -1) {
            printf("no winner (random winner %s)\n", robots[lrand48()&1].name);
        } else {
            printf("winner: %s\n", robots[winner].name);
        }
        mem_dump_profile();
        if (spimbot_exit_when_done) {
            exit(winner + 2);
        }
        fflush(stdout);
        return 0;
    }

    return -1;
}

void
draw_bot(QPainter* painter, bot_state_t *bot) {
    if (bot->done) {
        return;
    }

    QColor color = QColor(bot->color);

	 if (bot->snake) {
		bot->snake->drawSnake(painter, &color);
	 }
}

void
redraw_map_window(QPainter* painter) {

    // do scenario specific stuff
    redraw_scenario(painter);

    QPen pen(Qt::black);
    pen.setWidth(1);
    painter->setPen(pen);
    painter->drawLine(SCALE(0), SCALE(WORLD_SIZE) - 1, SCALE(WORLD_SIZE) - 1, SCALE(WORLD_SIZE) - 1);

    // re-draw bots and associated text
    for (int i = 0 ; i < num_contexts ; ++ i) {
        draw_bot(painter, &robots[i]);
        if (draw_text) {
            QFont font = QFont();
            font.setPointSize(8);
            painter->setFont(font);

            char str[200];
            scenario_set_bot_string(str, i);
            QString st = QString(str);
            
            painter->drawText(10, SCALE(WORLD_SIZE) + 20 + (i*20), st);

            painter->drawText(120, SCALE(WORLD_SIZE) + 20 + (i*20), robots[i].name);
            //painter->drawText(10, SCALE(WORLD_SIZE) + 20 + (i*20),
            //(char *)robots[i].scenario.apples_collected);
        }
    }

    write_output (message_out, "");
}

void
write_spimbot_IO(int context, mem_addr addr, mem_word value) {
    bool success = scenario_write_spimbot_IO(context, addr, value);

    if (success) {
        return;
    }

    bot_state_t *bot = &robots[context];
    switch (addr) {
    case SPIMBOT_BONK_ACK:
        if (spimbot_grading) {
            printf("bonk interrupt acknowledged\n");
            fflush(stdout);
        }
        CP0_Cause(reg_images[bot->context]) &= ~SB_BONK_INT_MASK;
        break;
    case SPIMBOT_TIMER_ACK:
        if (spimbot_grading) {
            printf("timer interrupt acknowledged\n");
            fflush(stdout);
        }
        CP0_Cause(reg_images[bot->context]) &= ~SB_TIMER_INT_MASK;
        break;
    case SPIMBOT_CYCLE:
        bot->timer = value;
        if (spimbot_grading) {
            printf("timer set after %d cycles\n", value - cycle);
            fflush(stdout);
        }
        break;
    case SPIMBOT_VEL_ADDR:
        //bot->velocity = MIN(10, MAX(-10, (int)value));
        break;
    case SPIMBOT_TURN_VALUE_ADDR:
        // if (spimbot_debug) printf("SPIMBOT_TURN_VALUE_ADDR");
        fflush(stdout);
        if ((value < -360) || (value > 360)) {
            if (spimbot_debug) {
                printf("turn value %d is out of range\n", value);
                fflush(stdout);
            }
        } else {
            bot->turn_value = value;
        }
        break;
    case SPIMBOT_TURN_CONTROL_ADDR:
        // if (spimbot_debug) printf("SPIMBOT_TURN_CONTROL_ADDR");
        fflush(stdout);
        int turn_amount;
        switch (value) {
        case SPIMBOT_RELATIVE_ANGLE_COMMAND:
            turn_amount = bot->snake->orientation + bot->turn_value;
            if ((bot->context == 1) && reverse_image) {
                turn_amount = turn_amount + 180;
            }
            turn_amount += 360;
            turn_amount %= 360;
            if (spimbot_debug) {
                //printf("relative orientation: %f %f\n", (int)bot->turn_value, bot->orientation);
                //fflush(stdout);
            }
            bot->snake->turnSnake(turn_amount);
            break;
        case SPIMBOT_ABSOLUTE_ANGLE_COMMAND: {
            turn_amount = bot->turn_value;
            if ((bot->context == 1) && reverse_image) {
                turn_amount = turn_amount + 180;
            }
            turn_amount += 360;
            turn_amount %= 360;
            if (spimbot_debug) {
                //printf("absolute orientation: %f %f\n", (int)bot->turn_value, bot->orientation);
                //fflush(stdout);
            }
            bot->snake->turnSnake(turn_amount);
            break;
        }
        default:
            if (spimbot_debug) {
                printf("unexpected angle command: %d\n", value);
                fflush(stdout);
            }
        }
        break;

    case SPIMBOT_PIVOT_NODES_X: {
        int i = 0;
        for (Snake::CoordinateList* p = bot->snake->list; p != NULL;
             p=p->next, i++)
        {
            set_mem_word(bot->context, addr+4*i, p->x);
        }
        while (i<256) {
            set_mem_word(bot->context, addr+4*i, -1);
            i++;
        }
        break;
    }

    case SPIMBOT_PIVOT_NODES_Y: {
        int i = 0;
        for (Snake::CoordinateList* p = bot->snake->list; p != NULL;
             p=p->next, i++)
        {
            set_mem_word(bot->context, addr+4*i, p->y);
        }
        while (i<256) {
            set_mem_word(bot->context, addr+4*i, -1);
            i++;
        }
        break;
    }

    case SPIMBOT_OTHER_PIVOT_NODES_X: {
        int i = 0;
        for (Snake::CoordinateList* p = robots[1 - bot->context].snake->list; p != NULL;
             p=p->next, i++)
        {
            set_mem_word(bot->context, addr+4*i, p->x);
        }
        while (i<256) {
            set_mem_word(bot->context, addr+4*i, -1);
            i++;
        }
        break;
    }

    case SPIMBOT_OTHER_PIVOT_NODES_Y: {
        int i = 0;
        for (Snake::CoordinateList* p = robots[1 - bot->context].snake->list; p != NULL;
             p=p->next, i++)
        {
            set_mem_word(bot->context, addr+4*i, p->y);
        }
        while (i<256) {
            set_mem_word(bot->context, addr+4*i, -1);
            i++;
        }
        break;
    }

    case SPIMBOT_PRINT_INT:
        if (!spimbot_tournament) {
            printf("%d\n", value);
            fflush(stdout);
        }
        break;
    case SPIMBOT_PRINT_HEX:
        if (!spimbot_tournament) {
            printf("%x\n", value);
            fflush(stdout);
        }
        break;
    case SPIMBOT_PRINT_FLOAT: {
        float *f = (float *)&value;
        if (!spimbot_tournament) {
            printf("%f\n", *f);
            fflush(stdout);
        }
        break;
    }
    default:
        run_error ("write to unused memory-mapped IO address (0x%x)\n", addr);
    }
}

mem_word
read_spimbot_IO(int context, mem_addr addr) {
    bool success = 0;

    mem_word ret_val = scenario_read_spimbot_IO(context, addr, &success);
    if (success) {
        return ret_val;
    }

    bot_state_t *bot = &robots[context];
    switch (addr) {
    case SPIMBOT_X_ADDR: {
        mem_word x = (mem_word)
                (((bot->context == 1) && reverse_image) ? (WORLD_SIZE - bot->snake->x()) : bot->snake->x());
        return x;
    }
    case SPIMBOT_Y_ADDR: {
        mem_word y = (mem_word)
                (((bot->context == 1) && reverse_image) ? (WORLD_SIZE - bot->snake->y()) : bot->snake->y());
        return y;
    }
    case SPIMBOT_OTHER_X_ADDR: {
        mem_word x = (mem_word)
                (((bot->context == 1) && reverse_image) ? (WORLD_SIZE - robots[1 - bot->context].snake->x()) : robots[1 - bot->context].snake->x());
        return x;
    }
    case SPIMBOT_OTHER_Y_ADDR: {
        mem_word y = (mem_word)
                (((bot->context == 1) && reverse_image) ? (WORLD_SIZE - robots[1 - bot->context].snake->y()) : robots[1 - bot->context].snake->y());
        return y;
    }
    case SPIMBOT_ANGLE_ADDR:
        return bot->snake->orientation;
    case SPIMBOT_VEL_ADDR:
        return mem_word(int(bot->velocity));
    case SPIMBOT_TURN_VALUE_ADDR:
        return bot->turn_value;
    case SPIMBOT_CYCLE:
        return cycle;

    default:
        run_error ("read from unused memory-mapped IO address (0x%x)\n", addr);
        return (0);
    }
}
