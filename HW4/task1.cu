#include <iostream>
#include <cuda.h>
#include "matmul.cuh"

using namespace std;

int main(int argc, char** argv){
	float *A, *B, *C;
	unsigned int n = atoi(argv[1]);
	unsigned int nthreads_perblock = atoi(argv[2]);

	cudaMallocManaged((void **)&A, n*n*sizeof(float));
	cudaMallocManaged((void **)&B, n*n*sizeof(float));
	cudaMallocManaged((void **)&C, n*n*sizeof(float));

	for(unsigned int i = 0; i < n; i++) {
		for(unsigned j = 0; j < n; j++) {
		A[n*i + j] = (float) ((i == j)? 1.0 : 0); //Identity Matrix
		B[n*i + j] = (float) n*i + j; 		 //Unique index matrix
		}
	}

	//Measure Time template
	cudaEvent_t start;
	cudaEvent_t stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start);
	
	matmul(A, B, C, n, nthreads_perblock);

	cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float ms = 0;
	cudaEventElapsedTime(&ms, start, stop);

	//Print template
	cout << C[n*n-1] << endl;
	cout << ms << endl;

	cudaFree(A);
	cudaFree(B);
	cudaFree(C);
return 0;
}
