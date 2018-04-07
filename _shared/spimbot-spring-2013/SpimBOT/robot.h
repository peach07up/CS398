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

#ifndef ROBOT_H
#define ROBOT_H

#include <math.h>

const int max_contexts = 2;

/* SCENARIO defitions and global */
#define SCENARIO_HEADER
#include "token_hunting.c"
#undef SCENARIO_HEADER

/* BOT defitions and global */
#include "snake.h"

typedef struct {
    int context;
    char name[80];
    unsigned color;

    Snake* snake;
    double velocity;
    //int orientation;
    int turn_value;
    bool bonk;
    bool done;

    int SNAKE_SHRINK_COUNTER;
    int SNAKE_GROWTH_COUNTER;

    scenario_bot_state_t scenario;

    int timer;

} bot_state_t;
extern const int BOT_RADIUS;
extern const int BOT_POINTER_LENGTH;

extern bot_state_t robots[2];
extern bool spimbot_tournament;

void world_initialize();
void bot_initialize(int context, bool randomize);
void redraw_map_window(QPainter* painter);
int world_update();

void spimbot_map_click();

#define SPIMBOT_IO_BOT ((mem_addr) 0xffff0000)
#define SPIMBOT_IO_TOP ((mem_addr) 0xffffffff)
#define SPIMBOT_VEL_ADDR ((mem_addr) 0xffff0010)
#define SPIMBOT_TURN_VALUE_ADDR ((mem_addr) 0xffff0014)
#define SPIMBOT_TURN_CONTROL_ADDR ((mem_addr) 0xffff0018)
#define SPIMBOT_CYCLE ((mem_addr) 0xffff001c)

#define SPIMBOT_RELATIVE_ANGLE_COMMAND 0
#define SPIMBOT_ABSOLUTE_ANGLE_COMMAND 1

#define SPIMBOT_X_ADDR ((mem_addr) 0xffff0020)
#define SPIMBOT_Y_ADDR ((mem_addr) 0xffff0024)

#define SPIMBOT_PIVOT_NODES_X ((mem_addr) 0xffff00c0)
#define SPIMBOT_PIVOT_NODES_Y ((mem_addr) 0xffff00c4)

#define SPIMBOT_EXIT_COMMAND ((mem_addr) 0xffff0030)
#define SPIMBOT_EXIT_X_ADDR ((mem_addr) 0xffff0038)
#define SPIMBOT_EXIT_Y_ADDR ((mem_addr) 0xffff003c)
#define SPIMBOT_ANGLE_ADDR ((mem_addr) 0xffff0040)

#define SPIMBOT_BONK_ACK ((mem_addr) 0xffff0060)
#define SPIMBOT_TIMER_ACK ((mem_addr) 0xffff006c)

#define SPIMBOT_PRINT_INT ((mem_addr) 0xffff0080)
#define SPIMBOT_PRINT_FLOAT ((mem_addr) 0xffff0084)
#define SPIMBOT_PRINT_HEX ((mem_addr) 0xffff0088)

#define SPIMBOT_OTHER_X_ADDR ((mem_addr) 0xffff00a0)
#define SPIMBOT_OTHER_Y_ADDR ((mem_addr) 0xffff00a4)

#define SPIMBOT_OTHER_PIVOT_NODES_X ((mem_addr) 0xffff00c8)
#define SPIMBOT_OTHER_PIVOT_NODES_Y ((mem_addr) 0xffff00cc)

#define SPIMBOT_REQUEST 1
#define SPIMBOT_ACKNOWLEDGE 2

void write_spimbot_IO(int context, mem_addr addr, mem_word value);
mem_word read_spimbot_IO(int context, mem_addr addr);

#define SB_BONK_INT_MASK 0x1000
#define SB_TIMER_INT_MASK 0x8000

#endif /* ROBOT_H */
