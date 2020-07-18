#include "cuda.h"
#include <cstdlib>
#include <iostream>
#include <thrust/copy.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/scan.h>
using namespace thrust;
int main(int argc, char **argv) {
  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  unsigned int n = atoi(argv[1]);
  host_vector<float> h_in(n);
  host_vector<float> h_out(n);
  device_vector<float> d_in(n);
  device_vector<float> d_out(n);
  for (unsigned int i = 0; i < n; i++)
    h_in[i] = (static_cast<float>(rand()) / static_cast<float>(RAND_MAX / 2));
  copy(h_in.begin(), h_in.end(), d_in.begin());
  cudaEventRecord(start);
  exclusive_scan(d_in.begin(), d_in.end(), d_out.begin());
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  copy(d_out.begin(), d_out.end(), h_out.begin());
  float ms;
  cudaEventElapsedTime(&ms, start, stop);

  std::cout << h_out[n - 1] << std::endl;
  std::cout << ms << std::endl;
  return 0;
}
