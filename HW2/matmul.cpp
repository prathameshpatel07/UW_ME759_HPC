#include <iostream>
using namespace std;

 void mmul1(const double* A, const double* B, double* C, const std::size_t n) {
 	for(unsigned int i = 0; i < n; i++) {
 	  for(unsigned int j = 0; j < n; j++) {
 	    for(unsigned int k = 0; k < n; k++) {
	 	C[n*i+j] += A[n*i+k]*B[k*n+j]; 
	    }
	  }
	}
 }

 void mmul2(const double* A, const double* B, double* C, const std::size_t n) {
 	for(unsigned int j = 0; j < n; j++) {
 	  for(unsigned int i = 0; i < n; i++) {
 	    for(unsigned int k = 0; k < n; k++) {
	 	C[n*i+j] += A[n*i+k]*B[k*n+j]; 
	    }
	  }
	}
 }

 void mmul3(const double* A, const double* B, double* C, const std::size_t n) {
 	for(unsigned int i = 0; i < n; i++) {
 	  for(unsigned int j = 0; j < n; j++) {
 	    for(unsigned int k = 0; k < n; k++) {
	 	C[n*i+j] += A[n*i+k]*B[n*j+k]; 
	    }
	  }
	}
 }

 void mmul4(const double* A, const double* B, double* C, const std::size_t n) {
 	for(unsigned int i = 0; i < n; i++) {
 	  for(unsigned int j = 0; j < n; j++) {
 	    for(unsigned int k = 0; k < n; k++) {
	 	C[n*i+j] += A[k*n+i]*B[k*n+j]; 
	    }
	  }
	}
 }
