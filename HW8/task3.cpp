#include <iostream>
#include <chrono>
#include <ratio>
#include <string.h>
#include <omp.h>
#include "msort.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
  unsigned int n  = atoi(argv[1]);
  unsigned int t  = atoi(argv[2]);
  unsigned int ts = atoi(argv[3]);
  int *arr;
  arr = new int[n];
  for(unsigned int i = 0; i < n; i++) {
	arr[i] = n - i;
  }
   
  omp_set_num_threads(t); 
  // Get the starting timestamp
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	msort(arr, n, ts);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);

	cout << arr[0] << endl;
	cout << arr[n-1] << endl;
    	cout << duration_sec.count() << endl;

delete[] arr;
return 0;
}
