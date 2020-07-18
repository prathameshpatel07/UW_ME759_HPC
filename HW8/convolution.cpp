#include <iostream>
#include <omp.h>
using namespace std;

void Convolve(const float *image, float *output, std::size_t n, const float *mask, std::size_t m) {
	  #pragma omp parallel for
	  for(unsigned int x = 0; x < n; x++) {
	    int w = 0;
	    int f = 0;
	    int g = 0;
	    for(unsigned int y = 0; y < n; y++) {
		g = n*x + y;
		output[g] = 0;
	     for(unsigned int i = 0; i < m; i++) {
	       for(unsigned int j = 0; j < m; j++) {
		w = m*i+j;
		f = n*(x + i - (m-1)/2) + (y + j - (m-1)/2);
		if( ((x + i - (m-1)/2) >= 0) && (((y + j - (m-1)/2)) >= 0) && 
		    ((x + i - (m-1)/2) <  n) && (((y + j - (m-1)/2)) < n)) {
			output[g] += mask[w] * image[f];
		}
	    }
	   }
	  }
	}
}
