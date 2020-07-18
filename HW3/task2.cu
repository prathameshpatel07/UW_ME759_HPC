#include <iostream>

using namespace std;

__global__ void task2(int *dA){
	int idx = threadIdx.x + blockIdx.x * blockDim.x;
	dA[idx] = threadIdx.x + blockIdx.x;
}

int main(){
	int *dA;
       	int *hA = new int[16];
	int size = 16*sizeof(int);

	cudaMalloc((void **)&dA, size);
	task2<<<2,8>>>(dA);
	cudaDeviceSynchronize();
	cudaMemcpy(hA, dA, size, cudaMemcpyDeviceToHost);

	for(int i = 1; i < 16; i++) {
		cout << hA[i] << " ";
	}
	cout << endl;

	cudaFree(dA);
	delete[] hA;
return 0;
}
