#include <stdio.h>
#include <stdlib.h>
#include <time.h>

const int matrixSize = 6;

// although their fields are exactly the same, defining these
// separately shows our intent better.

typedef struct HexMatrix {
    int size;
    unsigned char** data;
} HexMatrix;

typedef struct HexList {
    int size;
    unsigned char** data;
} HexList;

// dynamically allocate a matrix
HexMatrix* 
matrixMalloc(int size)
{
    HexMatrix* matrix = (HexMatrix*) malloc(sizeof(HexMatrix));
    matrix->size = size;
    matrix->data = (unsigned char**) malloc(size * sizeof(unsigned char*));
    for (int i = 0; i < size; ++ i)
    {
        matrix->data[i] = (unsigned char*) malloc(size * sizeof(unsigned char));
    }
    return matrix;
}

void 
freeMatrix(HexMatrix* matrix)
{
    for (int i = 0; i < matrix->size; ++ i) 
    {
        free(matrix->data[i]);
    }
    free(matrix->data);
    free(matrix);
}

void 
printMatrix(HexMatrix* matrix)
{
    for (int i = 0; i < matrix->size; ++ i)
    {
        for (int j = 0; j < matrix->size; ++ j)
        {
            printf("%x", matrix->data[i][j]);
        }
        printf("\n");
    }
}

// assume size is a multiple of 2
HexList* 
listMalloc(int size)
{
    HexList* list = (HexList*) malloc(sizeof(HexList));
    list->size = size;
    list->data = (unsigned char**) malloc(size * sizeof(unsigned char*));
    for (int i = 0; i < size; ++ i) 
    {
        list->data[i] = (unsigned char*) malloc(size / 2 * sizeof(unsigned char));
    }
    return list;
}

void 
freeList(HexList* list)
{
    for (int i = 0; i < list->size; ++ i)
    {
        free(list->data[i]);
    }
    free(list->data);
    free(list);
}

void 
printList(HexList* list)
{
    for (int i = 0; i < list->size; ++ i)
    {
        for (int j = 0; j < list->size / 2; ++ j)  
        {
            printf("%x", list->data[i][j]);
        }
        printf("\n");
    }
}

HexList* 
matrixToList(HexMatrix* matrix)
{
    HexList* list = listMalloc(matrix->size * 2);

    int rowCount = 0;
    int columnCount = 0;
    int rowIsAdded[matrix->size];
    int columnIsAdded[matrix->size];
    for (int i = 0; i < matrix->size; ++ i)
    {
        rowIsAdded[i] = 0;
        columnIsAdded[i] = 0;
    }

    srand(time(NULL));

    for (int i = 0; i < list->size; ++ i)
        if (((rand() & 1) && (rowCount != matrix->size)) || (columnCount == matrix->size))
        {
            int row = rand() % matrix->size;
            while (rowIsAdded[row])
            {
                row = rand() % matrix->size;
            }
            rowIsAdded[row] = 1;
            ++ rowCount;

            for (int column = 0; column < matrix->size; ++ column)
            {
                list->data[i][column] = matrix->data[row][column];
            }
        }
        else
        {
            int column = rand() % matrix->size;
            while (columnIsAdded[column])
            {
                column = rand() % matrix->size;
            }
            columnIsAdded[column] = 1;
            ++ columnCount;

            for (int row = 0; row < matrix->size; ++ row)
            {
                list->data[i][row] = matrix->data[row][column];
            }
        }

    return list;
}

// Generate a random matrix
HexMatrix* 
matrixGen(int size)
{
    HexMatrix* matrix = matrixMalloc(size);

    srand(time(NULL));
    for (int i = 0; i < size; ++ i)
    {
        for (int j = 0; j < size; ++ j)
        {
            matrix->data[i][j] = rand() & 0xf;
        }
    }

    return matrix;
}

// check that a resulting matrix could generate a given list.
int 
verify(HexMatrix* matrix, HexList* list)
{
    if (matrix->size * 2 != list->size)
    {
        return 0;
    }

    HexList* mList = matrixToList(matrix);

    int used[mList->size];
    for (int i = 0; i < mList->size; ++ i) {
        used[i] = 0;
	 }

    for (int i = 0; i < list->size; ++ i) {
        int hasMatch = 0;
        for (int j = 0; j < mList->size; ++ j)
        {
            if (!used[j]) {
                int match = 1;
                for (int k = 0; k < list->size / 2; ++ k) 
                {
                    if (list->data[i][k] != mList->data[j][k])
                    {
                        match = 0;
                        break;
                    }
                }
                if (match)
                {
                    used[j] = 1;
                    hasMatch = 1;
                    break;
                }
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

int 
matrix_column_matches_list_row(HexMatrix* matrix, int col, HexList* list, int row) {
    for (int k = 0; k < matrix->size; ++ k)    // check each element in row against column
    {
        if (matrix->data[k][col] != list->data[row][k])   
        {
            return 0;                          // if an element doesn't match, the row doesn't
        }
    }
	 return 1;
}

int 
any_matrix_column_matches_list_row(HexMatrix* matrix, HexList* list, int row) {
    for (int col = 0; col < matrix->size; ++ col)    // check against the col'th column
    {
        if (matrix_column_matches_list_row(matrix, col, list, row)) 
        { 
            return 1;
        }
    }
    return 0;
}

int 
check_remaining_columns(HexMatrix* matrix, HexList* list, unsigned int bitmask) 
{
    for (int i = 0; i < list->size; ++ i) 
    {
        if ((1L << i) & bitmask) { continue; }
        if (!any_matrix_column_matches_list_row(matrix, list, i)) {
            return 0;
        }
    }
    return 1;
}

// assume matrixSize is at most 32
int 
solve(HexMatrix* matrix, HexList* list, int depth, unsigned int bitmask)
{
    if (depth == matrix->size)  // check to see if the remaining list items match the columns
    {
        return check_remaining_columns(matrix, list, bitmask);
	 }

    for (int i = 0; i < list->size; ++ i) {
        if (((1L << i) & bitmask) == 0)
        {
            for (int j = 0; j < matrix->size; ++ j)
            {
                matrix->data[depth][j] = list->data[i][j];
            }

            if (solve(matrix, list, depth + 1, (1L << i) | bitmask))
            {
                return 1;
            }
        }
    }
    return 0;
}

int 
main()
{
    HexMatrix* matrix = matrixGen(matrixSize);
    printf("The randomly generated matrix is:\n\n");
    printMatrix(matrix);
    printf("\n");

    HexList* list = matrixToList(matrix);
    printf("The list generated from the matrix is:\n\n");
    printList(list);

    printf("\n");

    freeMatrix(matrix);
    matrix = matrixMalloc(matrixSize);

    // we need to backup the list before we give the list to students
    // we also need to backup the matrix data array
    solve(matrix, list, 0, 0);

    if (verify(matrix, list)) 
    {		
        printf("The matrix returned by solve is:\n\n");
    }
    else
    {
        printf("solve is broken:\n\n");
    }
    printMatrix(matrix);
    freeMatrix(matrix);
    freeList(list);
}
