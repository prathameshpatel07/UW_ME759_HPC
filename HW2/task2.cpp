#include <iostream>
#include <chrono>
#include <ratio>
#include "convolution.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
int n = atoi(argv[1]);
float *f, *w, *g;
f = new float[n*n];
w = new float[9];
g = new float[n*n];
for(int i = 0; i < n*n; i++) {
	f[i] = 2.0 * ((((float) rand()) / (float) RAND_MAX)) - 1.0;
	g[i] = 0;
}
for(int j = 0; j < 9; j++) {
	w[j] = 2.0 * ((((float) rand()) / (float) RAND_MAX)) - 1.0;
}
    // Get the starting timestamp
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
    
	start = high_resolution_clock::now();
	Convolve(f, g, n, w, 3); 
	end = high_resolution_clock::now();

	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    	cout << duration_sec.count() << endl;
	cout << g[0] << endl;
	cout << g[n*n-1] << endl;

delete[] f;
delete[] w;
delete[] g;
return 0;
}
