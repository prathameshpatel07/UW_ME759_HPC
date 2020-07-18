#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void stencil_kernel(const float* image, const float* mask, float* output, unsigned int n, unsigned int R) {
	extern __shared__ float shared_arr[];
	float *msk = shared_arr;
	float *out = (float*)&msk[2*R+1];
	float *img = (float*)&out[blockDim.x];

	//Read Input elements
	int gidx = threadIdx.x + blockIdx.x * blockDim.x;
	int lidx = threadIdx.x + R;

	img[lidx] = image[gidx];
	if(threadIdx.x < R) {
		if((gidx - (signed) R) < 0) { //signed added to remove warnings
			img[lidx-R] = 0;
			img[lidx + blockDim.x] = image[gidx + blockDim.x];
		}
		else if(gidx + blockDim.x >= n) { 
			img[lidx - R] = image[gidx - R];
			img[lidx + blockDim.x] = 0;
		}
		else {
		img[lidx - R] = image[gidx - R];
		img[lidx + blockDim.x] = image[gidx + blockDim.x];
		}
	}

	msk[threadIdx.x] = mask[threadIdx.x];
	out[threadIdx.x] = 0;
	__syncthreads();

	//Applying stencil function
	for(int j = 0; j <= 2*R; j++) {
		  out[threadIdx.x] += img[threadIdx.x+j] * mask[j];
	}
	output[gidx] = out[threadIdx.x];
}

__host__ void stencil(const float* image,
                      const float* mask,
                      float* output,
                      unsigned int n,
                      unsigned int R,
                      unsigned int threads_per_block) {

	unsigned int m = threads_per_block;
	size_t shared_array_size = (2*m + 4*R + 1)*sizeof(float); //Image=m+2R, Mask=2R+1, Output=m
	stencil_kernel<<<(n + m-1)/m, m, shared_array_size>>>(image, mask, output, n, R);
	cudaDeviceSynchronize();
}
