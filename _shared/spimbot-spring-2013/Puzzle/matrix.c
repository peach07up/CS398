#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#ifdef _MSC_VER
#include <vector>   // MSVC doesn't support VLAs
#endif

#ifdef MATRIX_HEADER

typedef struct HexMatrix
{
    int size;
    unsigned char** data;
} HexMatrix;

// although their fields are exactly the same, I decided to do this to avoid confusion
typedef struct HexList
{
    int size;
    unsigned char** data;
} HexList;

#else

HexMatrix* matrixMalloc(int size)
{
    HexMatrix* matrix = (HexMatrix*) malloc(sizeof(HexMatrix));
    matrix->size = size;
    matrix->data = (unsigned char**) malloc(size * sizeof(unsigned char*));
    for (int i = 0; i < size; ++ i)
        matrix->data[i] = (unsigned char*) malloc(size * sizeof(unsigned char));

    return matrix;
}

void freeMatrix(HexMatrix* matrix)
{
    for (int i = 0; i < matrix->size; ++ i)
        free(matrix->data[i]);
    free(matrix->data);
    free(matrix);
}

void printMatrix(HexMatrix* matrix)
{
    for (int i = 0; i < matrix->size; ++ i)
    {
        for (int j = 0; j < matrix->size; ++ j)
            printf("%x", matrix->data[i][j]);
        printf("\n");
    }
}

// assume size is a multiple of 2
HexList* listMalloc(int size)
{
    HexList* list = (HexList*) malloc(sizeof(HexList));
    list->size = size;
    list->data = (unsigned char**) malloc(size * sizeof(unsigned char*));
    for (int i = 0; i < size; ++ i)
        list->data[i] = (unsigned char*) malloc(size / 2 * sizeof(unsigned char));
    return list;
}

void freeList(HexList* list)
{
    for (int i = 0; i < list->size; ++ i)
        free(list->data[i]);
    free(list->data);
    free(list);
}

void printList(HexList* list)
{
    for (int i = 0; i < list->size; ++ i)
    {
        for (int j = 0; j < list->size / 2; ++ j)
            printf("%x", list->data[i][j]);
        printf("\n");
    }
}

bool trivial(HexMatrix* matrix, HexList* list)
{
    bool trivial = true;

    for (int i = 0; i < matrix->size; ++ i)
    {
        if (matrix->data[0][i] != list->data[0][i])
        {
            trivial = false;
        }
    }

    if (trivial)
        return true;

    trivial = true;

    for (int i = 0; i < matrix->size; ++ i)
    {
        if (matrix->data[i][0] != list->data[0][i])
        {
            trivial = false;
        }
    }

    return trivial;
}

HexList* matrixToList(HexMatrix* matrix)
{
    HexList* list = listMalloc(matrix->size * 2);

    do
    {
        int rowCount = 0;
        int columnCount = 0;
#ifndef _MSC_VER
        int rowIsAdded[matrix->size];
        int columnIsAdded[matrix->size];
        for (int i = 0; i < matrix->size; ++ i)
        {
            rowIsAdded[i] = 0;
            columnIsAdded[i] = 0;
        }
#else
        std::vector<int> rowIsAdded(matrix->size); // will zero-initialize
        std::vector<int> columnIsAdded(matrix->size);
#endif

        for (int i = 0; i < list->size; ++ i)
            if (((lrand48() & 1) && (rowCount != matrix->size)) || (columnCount == matrix->size))
            {
                int row = lrand48() % matrix->size;
                while (rowIsAdded[row])
                    row = lrand48() % matrix->size;
                rowIsAdded[row] = 1;
                ++ rowCount;

                for (int column = 0; column < matrix->size; ++ column)
                    list->data[i][column] = matrix->data[row][column];
            }
            else
            {
                int column = lrand48() % matrix->size;
                while (columnIsAdded[column])
                    column = lrand48() % matrix->size;
                columnIsAdded[column] = 1;
                ++ columnCount;

                for (int row = 0; row < matrix->size; ++ row)
                    list->data[i][row] = matrix->data[row][column];
            }
    }
    while (trivial(matrix, list));

    return list;
}

HexMatrix* matrixGen(int size)
{
    HexMatrix* matrix = matrixMalloc(size);

    for (int i = 0; i < size; ++ i)
        for (int j = 0; j < size; ++ j)
            matrix->data[i][j] = lrand48() & 0xf;

    return matrix;
}

int verify(HexMatrix* matrix, HexList* list)
{
    if (matrix->size * 2 != list->size)
        return 0;

    HexList* mList = matrixToList(matrix);

#ifndef _MSC_VER
    int used[mList->size];
    for (int i = 0; i < mList->size; ++ i)
        used[i] = 0;
#else
    std::vector<int> used(mList->size);
#endif

    for (int i = 0; i < list->size; ++ i) {
        int hasMatch = 0;
        for (int j = 0; j < mList->size; ++ j)
            if (!used[j]) {
                int match = 1;
                for (int k = 0; k < list->size / 2; ++ k)
                    if (list->data[i][k] != mList->data[j][k])
                    {
                        match = 0;
                        break;
                    }
                if (match)
                {
                    used[j] = 1;
                    hasMatch = 1;
                    break;
                }
            }
        if (!hasMatch)
        {
            freeList(mList);
            return 0;
        }
    }

    freeList(mList);
    return 1;
}

// assume matrixSize is at most 32
int solve(HexMatrix* matrix, HexList* list, int depth, long bitmask)
{
    if (depth == matrix->size)
        if (verify(matrix, list))
            return 1;
        else
            return 0;

    for (int i = 0; i < list->size; ++ i) {
        if (((1L << i) & bitmask) == 0)
        {
            for (int j = 0; j < matrix->size; ++ j)
                matrix->data[depth][j] = list->data[i][j];

            if (solve(matrix, list, depth + 1, (1L << i) | bitmask))
                return 1;
        }
    }
    return 0;
}

int matrix_column_matches_list_row(HexMatrix* matrix, int col, HexList* list, int row) {
    for (int k = 0; k < matrix->size; ++ k) {
        if (matrix->data[k][col] != list->data[row][k]) {
            return 0;
          }
    }
     return 1;
}

int any_matrix_column_matches_list_row(HexMatrix* matrix, HexList* list, int row) {
  for (int col = 0; col < matrix->size; ++ col) {   // check against the j'th column
     if (matrix_column_matches_list_row(matrix, col, list, row)) {
        return 1;
     }
  }
  return 0;
}

// assume matrixSize is at most 32
int new_solve(HexMatrix* matrix, HexList* list, int depth, long bitmask)
{
    if (depth == matrix->size) {  // check to see if the remaining list items match the columns
        for (int i = 0; i < list->size; ++ i) {
               if ((1L << i) & bitmask) { continue; }
                if (!any_matrix_column_matches_list_row(matrix, list, i)) {return 0;}
          }
          return 1;
     }

    for (int i = 0; i < list->size; ++ i) {
        if (((1L << i) & bitmask) == 0)
        {
            for (int j = 0; j < matrix->size; ++ j)
                matrix->data[depth][j] = list->data[i][j];

            if (new_solve(matrix, list, depth + 1, (1L << i) | bitmask))
                return 1;
        }
    }
    return 0;
}

#endif
