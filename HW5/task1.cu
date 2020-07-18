#include <iostream>
#include <cuda.h>
#include "reduce.cuh"

using namespace std;

int main(int argc, char** argv){
	int *arr;
	unsigned int n = atoi(argv[1]);
	unsigned int threads_per_block = atoi(argv[2]);
	int sum = 0;

	arr = new int[n];
	for(unsigned int i = 0; i < n; i++) {
		arr[i] = 1;
	}

	//Measure Time template
	cudaEvent_t start;
	cudaEvent_t stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start);
	
	sum = reduce(arr, n, threads_per_block);

	cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float ms = 0;
	cudaEventElapsedTime(&ms, start, stop);

	//Print template
	cout << sum << endl;
	cout << ms << endl;

	delete[] arr;
return 0;
}
