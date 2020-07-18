#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void reduce_kernel(const int* g_idata, int* g_odata, unsigned int n) {
	extern __shared__ int shared_arr[];
	int *sdata = shared_arr;
	unsigned int idx  = blockIdx.x*blockDim.x + threadIdx.x;
	unsigned int tidx = threadIdx.x;
	if(idx < n) {
		sdata[tidx] = g_idata[idx];
	}
	else
		sdata[tidx] = 0;

        __syncthreads();

	for (unsigned int s=blockDim.x/2; s>0; s>>=1) {
	    if (tidx < s) {
	          sdata[tidx] += sdata[tidx + s];
	    }
	    __syncthreads();
	}
    	if (tidx == 0) g_odata[blockIdx.x] = sdata[0];
}

__host__ int reduce(const int* arr, unsigned int N, unsigned int threads_per_block) {
	int *g_idata, *g_odata;
	unsigned int m = threads_per_block;
	size_t shared_array_size = m*sizeof(int);
	int blockdim = (N + m-1)/m;
	int *sum = new int[1];
	
	cudaMalloc((void **)&g_idata, N*sizeof(int));
	cudaMalloc((void **)&g_odata, blockdim*sizeof(int));
	cudaMemcpy(g_idata, arr, N*sizeof(int), cudaMemcpyHostToDevice);
	unsigned int nexti = 0;
	for(unsigned int i = N; i > 1; i=(i+ m-1)/m) {
		nexti = (i + m-1)/m;
		cudaMemset(g_odata, 0, blockdim*sizeof(int));
		
		reduce_kernel<<< blockdim, m, shared_array_size>>>(g_idata, g_odata, N);
		cudaDeviceSynchronize();
		
		cudaMemset(g_idata, 0, N*sizeof(int));
		if(nexti != 0) {
			cudaMemcpy(g_idata, g_odata, nexti*sizeof(int), cudaMemcpyDeviceToDevice);
		}
	}

	cudaMemcpy(sum, g_odata, 1*sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(g_idata);
	cudaFree(g_odata);
	return *sum;
}
