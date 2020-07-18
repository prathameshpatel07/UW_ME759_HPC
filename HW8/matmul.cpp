#include <iostream>
#include <omp.h>
using namespace std;

 void mmul(const float* A, const float* B, float* C, const std::size_t n) {
	#pragma omp parallel for
 	for(unsigned int i = 0; i < n; i++) {
 	  for(unsigned int j = 0; j < n; j++) {
	    C[n*i+j] = 0;
 	    for(unsigned int k = 0; k < n; k++) {
	 	C[n*i+j] += A[n*i+k]*B[n*j+k]; 
	    }
	  }
	}
 }
