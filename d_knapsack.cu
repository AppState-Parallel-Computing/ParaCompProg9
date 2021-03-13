#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <cuda_runtime.h>
#include "helpers.h"
#include "d_knapsack.h"

//prototypes for kernels in this file
__global__ 
void d_knapsackNaiveKernel(int * d_best, int * d_weight, int * d_values, int numObjs,
                           int capacity);

__global__ 
void d_knapsackOptKernel(int * d_best, int * d_weight, int * d_values, int numObjs,
                           int capacity);

/*  d_knapsack
    This function prepares and invokes a kernel to solve the 0-1 knapsack problem
    on the GPU. The input to the knapsack problem is a set of objects and a 
    knapsack capacity.  Each object has a weight and a value. The solution chooses a subset 
    of the objects that maximums the overall value while not exceeding the capacity.
    Inputs:
    result - points to an array to hold the knapsack result
    weights - points to an array that holds the weights of the objects
    values - points to an array that holds the values of the objects
    numObjs - number of objects (size of values and weights arrays)
    capacity - the capacity of the knapsack
    blkDim - the number of threads in the block of threads used to solve the problem
    which - indicates which kernel to use to solve the problem (NAIVE, OPT)
*/
float d_knapsack(int * result, int * weights, int * values, int numObjs, 
                 int capacity, int blkDim, int which)
{
    int * d_best, * d_weights, * d_values;  //pointers to arrays for GPU
   
    //CUERR is a macro in helpers.h that checks for a Cuda error 
    //Begin the timing (macro in helpers.h) 
    TIMERSTART(gpuTime)

    //Allocate space in GPU memory for weights array 
    cudaMalloc((void **)&d_weights, sizeof(int) * numObjs);             CUERR
    //Copy weights from CPU memory to GPU memory
    cudaMemcpy(d_weights, weights, sizeof(int) * numObjs, H2D);         CUERR

    //Allocate space in GPU memory for values array 
    cudaMalloc((void **)&d_values, sizeof(int) * numObjs);              CUERR
    //Copy values from CPU memory to GPU memory
    cudaMemcpy(d_values, values, sizeof(int) * numObjs, H2D);           CUERR

    //Launch the appropriate kernel
    if (which == NAIVE)
    {
        //Allocate space in GPU memory for best matrix
        int bestSz = (numObjs + 1) * (capacity + 1);
        cudaMalloc((void **)&d_best, sizeof(int) * bestSz);             CUERR
        //set the best matrix to 0
        cudaMemset((void *)d_best, 0, bestSz * sizeof(int));            CUERR
        //define the block and the grid and launch the naive kernel
        dim3 block(blkDim, 1, 1);
        dim3 grid(1, 1, 1);
        d_knapsackNaiveKernel<<<grid, block>>>(d_best, d_weights, d_values,
                                               numObjs, capacity);     CUERR
        //copy last row of d_best array into result
        cudaMemcpy(result, 
                   &d_best[numObjs * (capacity + 1)], sizeof(int) * (capacity + 1),
                   D2H);                                               CUERR
    } else if (which == OPT)
    {
        //TO DO
        //Provide the code that is missing to execute the optimized kernel

    }
    //free dynamically  allocated memory
    cudaFree(d_best);                                                 CUERR
    cudaFree(d_values);                                               CUERR
    cudaFree(d_weights);                                              CUERR

    //stop the timer
    TIMERSTOP(gpuTime)
    return TIMEELAPSED(gpuTime)
}

/*  
    d_knapsackNaiveKernel
    This kernel solves the knapsack problem using a naive kernel.
    Inputs:
    best - pointer to the array in which the result is stored
    weights - points to an array that holds the weights of the objects
    values - points to an array that holds the values of the objects
    numObjs - number of objects (size of values and weights arrays)
    capacity - the capacity of the knapsack
*/

__global__
void d_knapsackNaiveKernel(int * best, int * weights, int * values, 
                           int numObjs, int capacity)
{
    //TO DO

    //You should base this implementation on the CPU version in h_knapsack.cu, 
    //but the best array needs to be allocated before the kernel launch.

    //All threads of a block will cooperate in producing one row (i) of results.
    //Block synchronization is needed so the threads in a block won't continue
    //onto next row until all threads are finished with the current row.

    //The elements of a row are distributed among the threads in a block in
    //a cyclic manner.

    //The thread identifier is used by the thread to choose the first element
    //within the row that it is responsible for.  For example, for i equal 
    //to 0, thread 0 will write to best[0], best[blockDim.x], best[2*blockDim.x], etc.

}

/*  
    d_knapsackOptKernel
    This kernel solves the knapsack problem using an optimized kernel.
    Inputs:
    best - pointer to the array in which the result is stored
    weights - points to an array that holds the weights of the objects
    values - points to an array that holds the values of the objects
    numObjs - number of objects (size of values and weights arrays)
    capacity - the capacity of the knapsack
*/
__global__ 
void d_knapsackOptKernel(int * best, int * weights, int * values, int numObjs,
                         int capacity)
{
    //TO DO

    //For this one, start with the naive kernel code and improve it.
    //Specifically, reduce the number of accesses to global memory where you can.
    //Instead those accesses should access registers or shared memory.
    //This requires just a very simple modification of the code.

    //Second, use less global memory: O(capacity) instead of O(capacity * numObjs)
}      

