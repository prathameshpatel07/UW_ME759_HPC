#include <iostream>
#include <chrono>
#include <ratio>
#include "scan.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
int n = atoi(argv[1]);
float *r, *outr;
r = new float[n];
outr = new float[n];
for(int i = 0; i < n; i++) {
	r[i] = 2.0 * ((((float) rand()) / (float) RAND_MAX)) - 1.0;
}
    // Get the starting timestamp
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
    
	start = high_resolution_clock::now();
	Scan(r, outr, n); 
	end = high_resolution_clock::now();

	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    	cout << duration_sec.count() << endl;
	cout << outr[0] << endl;
	cout << outr[n-1] << endl;

delete[] r;
delete[] outr;
return 0;
}
