#include "count.cuh"
#include "cuda.h"
#include <cstdlib>
#include <iostream>
#include <thrust/copy.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/reduce.h>
using namespace thrust;
int main(int argc, char **argv) {
  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  unsigned int n = atoi(argv[1]);
  host_vector<int> h_in(n);
  host_vector<int> h_counts(n);
  host_vector<int> h_values(n);
  device_vector<int> d_in(n);
  device_vector<int> d_values(n);
  device_vector<int> d_counts(n);
  for (unsigned int i = 0; i < n; i++)
    h_in[i] = (static_cast<int>(rand()) / static_cast<int>(RAND_MAX / 10));
  copy(h_in.begin(), h_in.end(), d_in.begin());

  cudaEventRecord(start);
  count(d_in, d_values, d_counts);
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  copy(d_values.begin(), d_values.end(), h_values.begin());
  copy(d_counts.begin(), d_counts.end(), h_counts.begin());

  float ms;
  cudaEventElapsedTime(&ms, start, stop);

  int unique_n = d_values.end() - d_values.begin();
  std::cout << h_values[unique_n - 1] << std::endl;
  std::cout << h_counts[unique_n - 1] << std::endl;
  std::cout << ms << std::endl;
  return 0;
}
