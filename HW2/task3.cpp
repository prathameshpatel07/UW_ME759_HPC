#include <iostream>
#include <chrono>
#include <ratio>
#include <string.h>
#include "matmul.h"

using namespace std;
using namespace chrono;

int main(){
double *ar, *ac, *br, *bc, *c;
ar = new double[1000000];
ac = new double[1000000];
br = new double[1000000];
bc = new double[1000000];
double anum = 0.0;
double bnum = 0.0;
for(int i = 0; i < 1000; i++) {
  for(int j = 0; j < 1000; j++) {
	anum = 2.0 * ((((double) rand()) / (double) RAND_MAX)) - 1.0;
	bnum = 2.0 * ((((double) rand()) / (double) RAND_MAX)) - 1.0;
	ar[1000*i+j] = anum;
	br[1000*i+j] = bnum;
	ac[1000*j+i] = anum;
	bc[1000*j+i] = bnum;
  }
}
    // Get the starting timestamp
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
    
	cout << "1000" << endl;

	c = new double[1000000];

	for(int x1 = 0; x1 < 1000000; x1++) { c[x1] = 0; }
	start = high_resolution_clock::now();
	mmul1(ar, br, c, 1000);
	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    	cout << duration_sec.count() << endl;
	cout << c[999999] << endl;

	//memset(c, 0, sizeof(c));	
	for(int x2 = 0; x2 < 1000000; x2++) { c[x2] = 0; }
	start = high_resolution_clock::now();
	mmul2(ar, br, c, 1000);
	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    	cout << duration_sec.count() << endl;
	cout << c[999999] << endl;

//	memset(c, 0, sizeof(c));	
	for(int x3 = 0; x3 < 1000000; x3++) { c[x3] = 0; }
	start = high_resolution_clock::now();
	mmul3(ar, bc, c, 1000);
	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    	cout << duration_sec.count() << endl;
	cout << c[999999] << endl;

	//memset(c, 0, sizeof(c));	
	for(int x4 = 0; x4 < 1000000; x4++) { c[x4] = 0; }
	start = high_resolution_clock::now();
	mmul4(ac, br, c, 1000);
	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
    	cout << duration_sec.count() << endl;
	cout << c[999999] << endl;

delete[] ar;
delete[] ac;
delete[] br;
delete[] bc;
delete[] c;
return 0;
}
