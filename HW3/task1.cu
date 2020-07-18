#include <iostream>

using namespace std;

__global__ void task1(){
	printf("Hello World! I am thread %d.\n",threadIdx.x);
}

int main(){
	task1<<<1,4>>>();
	cudaDeviceSynchronize();
return 0;
}
