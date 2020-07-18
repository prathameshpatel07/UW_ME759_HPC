#include <iostream>
#include <cuda.h>
#include "cublas_v2.h"
#include "cuda_runtime.h"
#include "mmul.h"

using namespace std;

int main(int argc, char** argv){
	float *A, *B, *C;
//	float *dC;
	unsigned int n = atoi(argv[1]);
	unsigned int n_tests = atoi(argv[2]);
	cublasHandle_t handle;
	cublasCreate(&handle);

	cudaMallocManaged((void **)&A, n*n*sizeof(float));
	cudaMallocManaged((void **)&B, n*n*sizeof(float));
	cudaMallocManaged((void **)&C, n*n*sizeof(float));
	//cudaMalloc((void **)&dC, n*n*sizeof(float));

	for(unsigned int i = 0; i < n; i++) {
		for(unsigned j = 0; j < n; j++) {
		A[n*j + i] = (float) ((i == j)? 1.0 : 0); //Identity Matrix
		B[n*j + i] = (float) n*i + j; 		 //Unique index matrix
		C[n*j + i] = 0;
		}
	}
	//cublasSetMatrix(n, n, sizeof(float), A, n, B, n);
	//cublasGetMatrix(n, n, sizeof(float), C, n, dC, n);
	cublasSetMathMode(handle, CUBLAS_TENSOR_OP_MATH);
	//Measure Time template
	cudaEvent_t start;
	cudaEvent_t stop;
	float ms_sum = 0;
	for(int i = 0; i < n_tests; i++) {
	float ms = 0;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start);
	
	mmul(handle, A, B, C, n);

	cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&ms, start, stop);
	ms_sum += ms;
	}
	//Print template
	cout << ms_sum/n_tests << endl;

	cublasDestroy(handle);
	cudaFree(A);
	cudaFree(B);
	cudaFree(C);
return 0;
}
