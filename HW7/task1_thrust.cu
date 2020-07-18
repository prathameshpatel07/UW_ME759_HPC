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
  device_vector<int> d_in(n);
  for (unsigned int i = 0; i < n; i++)
    h_in[i] = (static_cast<int>(rand()) / static_cast<int>(RAND_MAX / 2));
  copy(h_in.begin(), h_in.end(), d_in.begin());
  cudaEventRecord(start);
  int sum = reduce(d_in.begin(), d_in.end(), (int)0, plus<int>());
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  float ms;
  cudaEventElapsedTime(&ms, start, stop);

  std::cout << sum << std::endl;
  std::cout << ms << std::endl;
  return 0;
}
