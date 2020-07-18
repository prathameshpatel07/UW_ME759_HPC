#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void matmul_kernel(const float* A, const float* B, float* C, unsigned int n) {

	int blocksize = blockDim.x;
	extern __shared__ float shared_arr[];
	float *As = shared_arr;
	float *Bs = (float*)&As[blocksize*blocksize];

	int bx = blockIdx.x;
	int by = blockIdx.y;
	int tx = threadIdx.x;
	int ty = threadIdx.y;
	int aBegin = by * blocksize * n;
	int aEnd = aBegin + n-1;
	int aStep = blocksize;
	int arow = aBegin/n + ty;
	int bBegin = bx * blocksize;
	int bStep = n * blocksize;
	int bcol = bBegin + tx;
	int c = n * blocksize * by + blocksize * bx;
	float Csub = 0;

	for (int a = aBegin, b = bBegin;a <= aEnd;a += aStep, b += bStep) {
		As[blocksize*ty + tx] = ((arow < n) && (a + tx <= aEnd))? A[a + n * ty + tx] : 0;
		Bs[blocksize*ty + tx] = ((bcol < n) && (a + tx <= aEnd))? B[b + n * ty + tx] : 0; 
		//Using aEnd condition for zero padding B matrix since column and row dimension of A and B respectively needs to be the same
		__syncthreads();
		for (int k = 0; k < blocksize; ++k)
			Csub += As[blocksize*ty + k] * Bs[blocksize*k + tx];
           	__syncthreads();
	}
	if((by*blocksize + ty < n) && (bx*blocksize + tx < n)) {
		C[c + n * ty + tx] = Csub;
	}
}

__host__ void matmul(const float* A, const float* B, float* C, unsigned int n, unsigned int block_dim) {
	dim3 dimBlock(block_dim, block_dim);
	dim3 dimGrid( (n + block_dim-1)/block_dim , (n + block_dim-1)/block_dim );
	size_t shared_array_size = (2*block_dim*block_dim)*sizeof(float);
	
	matmul_kernel<<<dimGrid, dimBlock, shared_array_size>>>(A, B, C, n);
	cudaDeviceSynchronize();
}
