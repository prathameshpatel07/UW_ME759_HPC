#include <iostream>
#include <chrono>
#include <ratio>
#include "convolution.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
int n = atoi(argv[1]);
float *f, *w, *g;
//f = new float[n*n];
f = new float[25];
w = new float[9];
g = new float[25];
//w = (float)(0.0,0.0,1.0,0.0,1.0,0.0,1.0,0.0,0.0);
//*f[] = (float){1.0,3.0,4.0,8.0,6.0,5.0,2.0,4.0,3.0,4.0,6.0,8.0,1.0,4.0,5.0,2.0};
w[0] = (float) {0.0};
w[1] = (float) {0.0};
w[2] = (float) {1.0};
w[3] = (float) {0.0};
w[4] = (float) {1.0};
w[5] = (float) {0.0};
w[6] = (float) {1.0};
w[7] = (float) {0.0};
w[8] = (float) {0.0};

f[0] = (float) {1.0};
f[1] = (float) {3.0};
f[2] = (float) {4.0};
f[3] = (float) {8.0};
f[4] = (float) {0.0};

f[5] = (float) {6.0};
f[6] = (float) {5.0};
f[7] = (float) {2.0};
f[8] = (float) {4.0};
f[9] = (float) {0.0};

f[10] = (float) {3.0};
f[11] = (float) {4.0};
f[12] = (float) {6.0};
f[13] = (float) {8.0};
f[14] = (float) {0.0};

f[15] = (float) {1.0};
f[16] = (float) {4.0};
f[17] = (float) {5.0};
f[18] = (float) {2.0};
f[19] = (float) {0.0};

f[20] = (float) {0.0};
f[21] = (float) {0.0};
f[22] = (float) {0.0};
f[23] = (float) {0.0};
f[24] = (float) {0.0};
for(int i = 0; i < 25; i++) {
//	f[i] = 2.0 * ((((float) rand()) / (float) RAND_MAX)) - 1.0;
	cout << " f:" <<  f[i];
	g[i] = 0;
}
for(int j = 0; j < 9; j++) {
//	f[i] = 2.0 * ((((float) rand()) / (float) RAND_MAX)) - 1.0;
	cout << "w:" <<  w[j];
}
    // Get the starting timestamp
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
    
	start = high_resolution_clock::now();
	Convolve(f, g, 5, w, 3); 
	end = high_resolution_clock::now();

	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
//    	cout << duration_sec.count() << endl;
for(int m = 0; m < 25; m++) {
//	f[i] = 2.0 * ((((float) rand()) / (float) RAND_MAX)) - 1.0;
	cout << "g:" <<  g[m] << endl;
}

delete[] f;
delete[] w;
delete[] g;
return 0;
}
