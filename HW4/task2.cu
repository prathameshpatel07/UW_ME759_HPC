#include <iostream>
#include <cuda.h>
#include "stencil.cuh"

using namespace std;

int main(int argc, char** argv){
	float *img, *mask, *out;
	unsigned int n = atoi(argv[1]);
	unsigned int R = atoi(argv[2]);
	unsigned int threads_per_block = atoi(argv[3]);

	cudaMallocManaged((void **)&img, n*sizeof(float));
	cudaMallocManaged((void **)&mask, (2*R+1)*sizeof(float));
	cudaMallocManaged((void **)&out, n*sizeof(float));

	for(unsigned int i = 0; i < n; i++) {
		img[i] = (float) i;
	}
	for(unsigned int j = 0; j < 2*R+1; j++) {
		mask[j] = (j == R)? 1.0 : 0;
	}

	//Measure Time template
	cudaEvent_t start;
	cudaEvent_t stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start);
	
	stencil(img, mask, out, n, R, threads_per_block);

	cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float ms = 0;
	cudaEventElapsedTime(&ms, start, stop);

	//Print template
	cout << out[n-1] << endl;
	cout << ms << endl;

	cudaFree(img);
	cudaFree(mask);
	cudaFree(out);
return 0;
}
