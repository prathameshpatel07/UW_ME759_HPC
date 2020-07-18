#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <chrono>
#include <ratio>
#include <string.h>
#include "optimize.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
  int n = atoi(argv[1]);
  vec *v = new vec(n);
  v->data = new data_t[n];
  data_t *dest = new data_t;

  for(data_t i = 0; i < n; i++) {
	  v->data[i] = i;
  }
  // Get the starting timestamp
  duration<double, std::milli> duration_sec_avg;
  high_resolution_clock::time_point dummy;
  dummy = high_resolution_clock::now();

  //OPT1
  duration_sec_avg = std::chrono::duration_cast<duration<double, std::milli>>(dummy - dummy);
  for(int x = 0; x < 10; x++) {
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	optimize1(v, dest);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
	duration_sec_avg += duration_sec;
  }
	cout << *dest << endl;
    	cout << duration_sec_avg.count()/10 << endl;

  //OPT2
  duration_sec_avg = std::chrono::duration_cast<duration<double, std::milli>>(dummy - dummy);
  for(int x = 0; x < 10; x++) {
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	optimize2(v, dest);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
	duration_sec_avg += duration_sec;
  }
	cout << *dest << endl;
    	cout << duration_sec_avg.count()/10 << endl;

  //OPT3
  duration_sec_avg = std::chrono::duration_cast<duration<double, std::milli>>(dummy - dummy);
  for(int x = 0; x < 10; x++) {
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	optimize3(v, dest);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
	duration_sec_avg += duration_sec;
  }
	cout << *dest << endl;
    	cout << duration_sec_avg.count()/10 << endl;

  //OPT4
  duration_sec_avg = std::chrono::duration_cast<duration<double, std::milli>>(dummy - dummy);
  for(int x = 0; x < 10; x++) {
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	optimize4(v, dest);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
	duration_sec_avg += duration_sec;
  }
	cout << *dest << endl;
    	cout << duration_sec_avg.count()/10 << endl;

  //OPT5
  duration_sec_avg = std::chrono::duration_cast<duration<double, std::milli>>(dummy - dummy);
  for(int x = 0; x < 10; x++) {
	high_resolution_clock::time_point start;
	high_resolution_clock::time_point end;
    	duration<double, std::milli> duration_sec;
	start = high_resolution_clock::now();

	optimize5(v, dest);

	end = high_resolution_clock::now();
	duration_sec = std::chrono::duration_cast<duration<double, std::milli>>(end - start);
	duration_sec_avg += duration_sec;
  }
	cout << *dest << endl;
    	cout << duration_sec_avg.count()/10 << endl;

delete[] v;
return 0;
}
