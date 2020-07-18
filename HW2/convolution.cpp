#include <iostream>
using namespace std;

void Convolve(const float *image, float *output, std::size_t n, const float *mask, std::size_t m) {
	int w = 0;
	int f = 0;
	int g = 0;
	  for(unsigned int x = 0; x < n; x++) {
			//cout << "x:"<< x << endl;
	    for(unsigned int y = 0; y < n; y++) {
			//cout << "y:"<< y << endl;
	for(unsigned int i = 0; i < m; i++) {
	 for(unsigned int j = 0; j < m; j++) {
		w = m*i+j;
		f = n*(x + i - (m-1)/2) + (y + j - (m-1)/2);
		g = n*x + y;
		if( ((x + i - (m-1)/2) >= 0) || (((y + j - (m-1)/2)) >= 0) ) {
			output[g] += mask[w] * image[f];
		}
	    }
	   }
	  }
	}
}
