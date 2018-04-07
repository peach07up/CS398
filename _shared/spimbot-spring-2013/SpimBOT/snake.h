/*
This file implements snake functions.
The snake is stored as a list of coordinates and head orientation.
The fisrt coordinate is the position of the head.
The last coordinate is the position of the tail.
The rest coordinates are the positions where the snake bent.
The orientation is designed in a way such that:
only 0, 90, 180, 270 are accepted as legal value,
0 corresponds to move right,
90 corresponds to move up,
180 corresponds to move left,
270 corresponds to move down.
*/



class Snake {

public:

    static const int listLimit = 256;

    class CoordinateList {

    public:

        double x, y;
        CoordinateList* next;
    };

    CoordinateList* list;
    int orientation;
    int listLength;

    /*
     * This is the only constructor that should be used.
     * It creates a snake with only one segment.
     * If the orientation given is illegal, it will be set to 0.
     * It assumes that all the rest values are legal.
     * Param:   head_x          x-coordinate of the head
     *          head_y          y-coordinate of the head
     *          tail_x          x-coordiante of the tail
     *          tail_y          y-coordiante of the tail
     *          orientation     initial orientation of the snake
     * Return:  nothing
     */
    Snake(double head_x, double head_y, double tail_x, double tail_y,
          int orientation);

    /*
     * Destructor.
     * Params:  nothing
     * Return:  nothing
     */
    ~Snake();

    /*
     * This method returns the x coordinate of the head.
     * Params:  nothing
     * Return:  an int which is the x coordinate of the head
     */
    int x();

    /*
     * This method returns the y coordinate of the head.
     * Params:  nothing
     * Return:  an int which is the y coordinate of the head
     */
    int y();

    /*
     * This method moves the snake if possible under the given environment.
     * It assumes that all the values given are legal.
     * Params:  step            the length to move
     *          moveHead        whether to move head
     *          moveTail        whether to move tail
     *          snakes          the list of other snakes in the world
     *          snakesCount     the number of snakes in the list
     *          min_x           the min x-coordinate of the world
     *          min_y           the min y-coordinate of the world
     *          max_x           the max x-coordinate of the world
     *          max_y           the max y-coordinate of the world
     * Return   0               if the snake moves successfully
     *          1               if the snake hits the boundary of the world
     *          2               if the snake hits other snakes
     *          3               if the snake hits itself
     */
    int moveSnake(double step, bool moveHead, bool moveTail,
                  Snake* snakes[], int snakesCount,
                  double min_x, double min_y, double max_x, double max_y);

    /*
     * This method turns the snake head to the given orientation if possible.
     * It assumes the orientation given is legal.
     * Params:  orientation     the orientation to turn
     * Return:  true            if the snake turns successfully
     *          false           if it is impossible to turn to the given orientation
     */
    bool turnSnake(int orientation);

    /*
     * This method draws the snake via the painter passed.
     * Params:  painter         the QPainter which the drawing is performed on
     *          color           the color of the snake
     */
    void drawSnake(QPainter* painter, QColor* color);

    /*
     * This method calculates the length of the snake.
     * Params:  nothing
     * Return:  the length of the snake
     */
    double snakeLength();

    /*
     * This method delete the tail segment of the snake.
     * Params:  nothing
     * Return:  nothing
     */
    void deleteTail();

    /*
     * This method checks if this snake collide with another snake.
     * Params:  onther          the other snake
     * Return:  true            if two snakes collide
     *          false           if they do not
     */
    bool isCollidedWith(Snake* other);

    /*
     * This method checks if this snake collide with itself.
     * Params:  nothing
     * Return:  true            if the snake collides with itself
     *          false           if it does not
     */
    bool isCollidedWithSelf();

};
