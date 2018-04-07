#include <QPainter>

#include <stdio.h>
#include <stdlib.h>
#include "snake.h"

Snake::Snake(double head_x, double head_y, double tail_x, double tail_y,
             int orientation)
{
    list = new CoordinateList;
    list->x = head_x;
    list->y = head_y;
    list->next = new CoordinateList;
    list->next->x = tail_x;
    list->next->y = tail_y;
    list->next->next = NULL;
    this->orientation = orientation == 0 || orientation == 90
            || orientation == 180 || orientation == 270 ? orientation : 0;
    listLength = 2;
}

Snake::~Snake()
{
    CoordinateList* p = list;
    CoordinateList* q = list->next;

    while (q != NULL)
    {
        delete p;
        p = q;
        q = q->next;
    }
    delete p;
}

int Snake::x()
{
    return list->x;
}

int Snake::y()
{
    return list->y;
}

int Snake::moveSnake(double step, bool moveHead, bool moveTail,
                     Snake* snakes[], int snakesCount,
                     double min_x, double min_y, double max_x, double max_y)
{
    double prev_x = list->x;
    double prev_y = list->y;

    // move the head
    if (moveHead)
    {
        switch (orientation)
        {
            case 0 :    list->x += step;
                break;
            case 90 :   list->y += step;
                break;
            case 180 :  list->x -= step;
                break;
            case 270 :  list->y -= step;
                break;
            default :   printf("Illegal orientation value.\n");
                        fflush(stdout);
        }
    }

    // check collisions with boundaries
    bool collidedWithBoundaries = list->x < min_x || list->x > max_x
            || list->y < min_y || list->y > max_y;

    // check collisions with other snakes
    bool collidedWithSnakes = false;
    for (int i = 0; i < snakesCount; ++ i)
        if(isCollidedWith(snakes[i]))
        {
            collidedWithSnakes = true;
            break;
        }

    // check collisions with itself
    bool collidedWithSelf = isCollidedWithSelf();

    // move the tail
    if (moveTail)
    {
        CoordinateList* p = list;
        double x = 0;
        double y = 0;

        while (p->next != NULL)
        {
            x = p->x;
            y = p->y;
            p = p->next;
        }

        if (x == p->x)
            if (y < p->y)
            {
                p->y -= step;
                if (y >= p->y)
                    deleteTail();
            }
            else
            {
                p->y += step;
                if (y <= p->y)
                    deleteTail();
            }
        else
            if (x < p->x)
            {
                p->x -= step;
                if (x >= p->x)
                    deleteTail();
            }
            else
            {
                p->x += step;
                if (x <= p->x)
                    deleteTail();
            }
    }

    if (collidedWithBoundaries)
    {
        list->x = prev_x;
        list->y = prev_y;
        return 1;
    }
    if (collidedWithSnakes)
    {
        list->x = prev_x;
        list->y = prev_y;
        return 2;
    }
    if (collidedWithSelf)
    {
        list->x = prev_x;
        list->y = prev_y;
        return 3;
    }
    return 0;
}

bool Snake::turnSnake(int orientation)
{
    if (orientation == this->orientation)
        return true;

    if (abs(orientation - this->orientation) == 180)
        return false;

    if (listLength > 256)
        return false;

    this->orientation = orientation;

    if (list->x == list->next->x && list->y == list->next->y)
        return true;

    CoordinateList* p = list;
    list = new CoordinateList;
    list->x = p->x;
    list->y = p->y;
    list->next = p;
    ++ listLength;

    return true;
}

void Snake::drawSnake(QPainter* painter, QColor* color)
{
    QPen pen(*color);
    QBrush brush(Qt::SolidPattern);
    brush.setColor(*color);

    painter->setPen(pen);
    painter->setBrush(brush);

    CoordinateList* p = list->next;
    double x = list->x;
    double y = list->y;
    while (p != NULL)
    {
        painter->drawLine(x, y, p->x, p->y);

        x = p->x;
        y = p->y;
        p = p->next;
    }
}

double Snake::snakeLength()
{
    double length = 0;

    CoordinateList* p = list->next;
    double x = list->x;
    double y = list->y;

    while (p != NULL)
    {
        if (x == p->x)
        {
            length += abs(p->y - y);
        }
        else
        {
            length += abs(p->x - x);
        }

        x = p->x;
        y = p->y;
        p = p->next;
    }

    return length;
}

void Snake::deleteTail()
{
    CoordinateList* p = list;

    if (p->next->next == NULL)
    {
        return;
    }

    while (p->next->next != NULL)
    {
        p = p->next;
    }

    delete p->next;
    p->next = NULL;

    -- listLength;
}

bool Snake::isCollidedWith(Snake* other)
{
    double h_x = list->x;
    double h_y = list->y;
    double t_x = list->next->x;
    double t_y = list->next->y;

    bool horizontal = h_y == t_y;

    double o_x = other->list->x;
    double o_y = other->list->y;
    CoordinateList* p = other->list->next;

    // loop through line segments the other snake has
    while (p != NULL)
    {
        bool o_horizontal = o_y == p->y;

        if (horizontal != o_horizontal)
        {
            if (horizontal)
            {
                bool above1 = (int) o_y < (int) h_y;
                bool above2 = (int) p->y < (int) h_y;
                bool below1 = (int) o_y > (int) h_y;
                bool below2 = (int) p->y > (int) h_y;
                bool left1 = (int) h_x < (int) o_x;
                bool left2 = (int) t_x < (int) o_x;
                bool right1 = (int) h_x > (int) o_x;
                bool right2 = (int) t_x > (int) o_x;
                if (!(left1 == left2 && right1 == right2)
                        && !(above1 == above2 && below1 == below2))
                {
                    return true;
                }
            }
            else
            {
                bool above1 = (int) h_y < (int) o_y;
                bool above2 = (int) t_y < (int) o_y;
                bool below1 = (int) h_y > (int) o_y;
                bool below2 = (int) t_y > (int) o_y;
                bool left1 = (int) o_x < (int) h_x;
                bool left2 = (int) p->x < (int) h_x;
                bool right1 = (int) o_x > (int) h_x;
                bool right2 = (int) p->x > (int) h_x;
                if (!(left1 == left2 && right1 == right2)
                        && !(above1 == above2 && below1 == below2))
                {
                    return true;
                }
            }
        }

        o_x = p->x;
        o_y = p->y;
        p = p->next;
    }

    return false;
}

bool Snake::isCollidedWithSelf()
{
    double h_x = list->x;
    double h_y = list->y;
    double t_x = list->next->x;
    double t_y = list->next->y;

    bool horizontal = h_y == t_y;

    double o_x;
    double o_y;
    CoordinateList* p = list->next->next;

    if (p != NULL)
    {
        o_x = p->x;
        o_y = p->y;
        p = p->next;
    }

    // loop through line segments the other snake has
    while (p != NULL)
    {
        bool o_horizontal = o_y == p->y;

        if (horizontal != o_horizontal)
        {
            if (horizontal)
            {
                bool above1 = o_y <= h_y;
                bool above2 = p->y <= h_y;
                bool left1 = h_x <= o_x;
                bool left2 = t_x <= o_x;
                if (above1 != above2 && left1 != left2)
                {
                    return true;
                }
            }
            else
            {
                bool above1 = h_y <= o_y;
                bool above2 = t_y <= o_y;
                bool left1 = o_x <= h_x;
                bool left2 = p->x <= h_x;
                if (above1 != above2 && left1 != left2)
                {
                    return true;
                }
            }
        }

        o_x = p->x;
        o_y = p->y;
        p = p->next;
    }

    return false;
}
