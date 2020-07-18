#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <chrono>
#include <ratio>
#include <string.h>
#include <omp.h>
#include "cluster.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
  unsigned int n = atoi(argv[1]);
  unsigned int t = atoi(argv[2]);
  int *arr, *centers, *dists;
  int maxdists = 0;
  int tnum     = 0;
 
  arr 	  = new int[n];
  centers = new int[t];
  dists   = new int[t];
  for(unsigned int i = 0; i < n; i++) {
	  arr[i] = rand()%(n+1);
  }
  for(unsigned int j = 0; j < t; j++) {
	  centers[j] = ((2*j+1)*n)/(2*t);
  }
  sort(arr, arr+n); 
  // Get the starting timestamp
  duration<double, std::milli> duration_sec_avg;
  high_resolution_clock::time_point dummy;
  dummy = high_resolution_clock::now();
  duration_sec_avg = std::chrono::duration_cast<duration<double, std::milli>>(dummy - dummy);
  for(int x = 0; x < 10; x++) {
	  for(unsigned int p = 0; p < t; p++) {
	  	dists[p] = 0;
	  }
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	cluster(n, t, arr, centers, dists);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
	duration_sec_avg += duration_sec;
  }

  for(unsigned int k = 0; k < t; k++) {
  	if (maxdists < dists[k]) {
		maxdists = dists[k];
		tnum     = k;
	}
  }
	cout << maxdists << endl;
	cout << tnum << endl;
    	cout << duration_sec_avg.count()/10 << endl;

delete[] arr;
delete[] centers;
delete[] dists;
return 0;
}
