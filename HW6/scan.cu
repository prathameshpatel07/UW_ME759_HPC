#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void hillis_steele(float *g_odata, float *g_idata, float *blocksum, int n) {
    	extern volatile __shared__  float temp[]; // allocated on invocation
    	int pout = 0, pin = 1;
	int idx  = blockIdx.x*blockDim.x + threadIdx.x;
    	int thid = threadIdx.x;
	int m = blockDim.x;
	temp[thid] = (idx == 0 || idx >= n) ? 0: g_idata[idx-1];
	__syncthreads();
        for( int offset = 1; offset<m; offset *= 2 ) {
	        pout = 1 - pout; // swap double buffer indices
	        pin  = 1 - pout;
	        if (thid >= offset)
	            temp[pout*m+thid] = temp[pin*m+thid] + temp[pin*m+thid - offset];
		else
		    temp[pout*m+thid] = temp[pin*m+thid];
	        __syncthreads(); // I need this here before I start next iteration 
	}
	g_odata[idx] = temp[pout*m+thid]; // write output
	if(thid == blockDim.x -1 || idx == n-1) 
		blocksum[blockIdx.x] = temp[pout*m+thid];
}

__global__ void sum_kernel(float *g_odata, float *blocksum, int n) {
	int idx  = blockIdx.x*blockDim.x + threadIdx.x;
	if(idx < n) {
		g_odata[idx] += blocksum[blockIdx.x];
	}
}
__host__ void scan(const float* in, float* out, unsigned int n, unsigned int threads_per_block) {
	float *g_idata, *g_odata;
	float *blocksum_in, *blocksum_out, *dummy;
	unsigned int m = threads_per_block;
	size_t shared_array_size = 2*m*sizeof(float);
	int blockdim = (n + m-1)/m;
	//float *blocksum = new float[blockdim];
	
	cudaMalloc((void **)&g_idata, n*sizeof(float));
	cudaMalloc((void **)&g_odata, n*sizeof(float));
	cudaMallocManaged((void **)&blocksum_in, blockdim*sizeof(float));
	//cudaMalloc((void **)&blocksum_out, blockdim*sizeof(float));
	cudaMallocManaged((void **)&blocksum_out, blockdim*sizeof(float));
	cudaMallocManaged((void **)&dummy, 1*sizeof(float));
	cudaMemcpy(g_idata, in, n*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemset(g_odata, 0, n*sizeof(float));
		
	hillis_steele<<<blockdim, m, shared_array_size>>>(g_odata, g_idata, blocksum_in, n);
	cudaDeviceSynchronize();

	hillis_steele<<<1, m, shared_array_size>>>(blocksum_out, blocksum_in, dummy, blockdim);
	cudaDeviceSynchronize();
	
	sum_kernel<<<blockdim, m>>>(g_odata, blocksum_out, n);
	cudaDeviceSynchronize();

	cudaMemcpy(out, g_odata, n*sizeof(float), cudaMemcpyDeviceToHost);
	cudaDeviceSynchronize();

	cudaFree(g_idata);
	cudaFree(g_odata);
}
