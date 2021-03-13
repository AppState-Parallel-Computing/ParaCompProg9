NVCC = /usr/local/cuda-11.1/bin/nvcc
CC = g++

#Optimization flags. Don't use this for debugging.
NVCCFLAGS = -c -m64 -O2 --compiler-options -Wall -Xptxas -O2,-v

#No optimizations. Debugging flags. Use this for debugging.
#NVCCFLAGS = -c -g -G -m64 --compiler-options -Wall

OBJS = wrappers.o knapsack.o h_knapsack.o d_knapsack.o
.SUFFIXES: .cu .o .h 
.cu.o:
	$(NVCC) $(NVCCFLAGS) $(GENCODE_FLAGS) $< -o $@

knapsack: $(OBJS)
	$(CC) $(OBJS) -L/usr/local/cuda/lib64 -lcuda -lcudart -o knapsack

knapsack.o: knapsack.cu h_knapsack.h d_knapsack.h helpers.h wrappers.h

h_knapsack.o: h_knapsack.cu h_knapsack.h helpers.h wrappers.h 

d_knapsack.o: d_knapsack.cu d_knapsack.h helpers.h

wrappers.o: wrappers.cu wrappers.h

clean:
	rm knapsack *.o
