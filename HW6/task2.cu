#include <iostream>
#include <cuda.h>
#include "scan.cuh"

using namespace std;

int main(int argc, char** argv){
	float *in, *out;
	unsigned int n = atoi(argv[1]);
	unsigned int threads_per_block = 1024;
	in = new float[n];
	out = new float[n];
	for(unsigned int i = 0; i < n; i++) {
		in[i] = 1;
	}

	//Measure Time template
	cudaEvent_t start;
	cudaEvent_t stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start);
	
	scan(in, out, n, threads_per_block);

	cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float ms = 0;
	cudaEventElapsedTime(&ms, start, stop);

	//Print template
	cout << out[n-1] << endl;
	cout << ms << endl;

	delete[] in;
	delete[] out;
return 0;
}
