#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n) {
	unsigned int idx = threadIdx.x + blockIdx.x * blockDim.x;
	unsigned int row_idx = idx/n;
	unsigned int col_idx = idx%n;
	C[idx] = 0;
	if(idx < n*n) {
	 	for(unsigned int k = 0; k < n; k++) {
			C[idx] += A[n*row_idx + k] * B[n*k + col_idx];
		}	
	}
}

void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block) {
	unsigned int m = threads_per_block;
	matmul_kernel<<<(n*n + m-1)/m, m>>>(A, B, C, n);
	cudaDeviceSynchronize();
}
