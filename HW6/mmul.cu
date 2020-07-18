#include "cublas_v2.h"
#include "cuda_runtime.h"
void mmul(cublasHandle_t handle, const float* A, const float* B, float* C, int n) {
	const float one = 1;
	const float zero = 0;
	const float *alpha = &one;
	const float *beta = &zero;
	cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, n, n, alpha, A, n, B, n, beta, C, n);	
	cudaDeviceSynchronize();
}
