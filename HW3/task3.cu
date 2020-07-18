#include <iostream>
#include "vadd.cuh"

using namespace std;

int main(int argc, char** argv){
	float *a, *b;
	float *da, *db;
	unsigned int n = atoi(argv[1]);
	unsigned int size = n*sizeof(float);
	int m = 512; //Threads per block

	a = new float[n];
	b = new float[n];

	for(unsigned int i = 0; i < n; i++) {
		a[i] = (float) i;
		b[i] = (float) 2 * i;
	}

	cudaMalloc((void **)&da, size);
	cudaMalloc((void **)&db, size);

	cudaMemcpy(da, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(db, b, size, cudaMemcpyHostToDevice);

	//Measure Time template
	cudaEvent_t start;
	cudaEvent_t stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start);
	
	vadd<<<(n + m-1)/m, m>>>(da, db, n);

//`	cudaDeviceSynchronize();

	cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float ms = 0;
	cudaEventElapsedTime(&ms, start, stop);

	cudaMemcpy(b, db, size, cudaMemcpyDeviceToHost);
	//Print template
	cout << ms/1000 << endl;
	cout << b[0] << endl;
	cout << b[n-1] << endl;

	cudaFree(da);
	cudaFree(db);
	delete[] a;
	delete[] b;
return 0;
}
