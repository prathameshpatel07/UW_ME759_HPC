#define CUB_STDERR // print CUDA runtime errors to console
#include <cub/device/device_reduce.cuh>
#include <cub/util_allocator.cuh>
#include <stdio.h>
using namespace cub;
CachingDeviceAllocator g_allocator(true); // Caching allocator for device memory

int main(int argc, char **argv) {
  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  unsigned int n = atoi(argv[1]);
  int *h_in = new int[n];
  for (unsigned int i = 0; i < n; i++)
    h_in[i] = (static_cast<int>(rand()) / static_cast<int>(RAND_MAX / 2));

  // Set up device arrays
  int *d_in = NULL;
  CubDebugExit(g_allocator.DeviceAllocate((void **)&d_in, sizeof(int) * n));
  // Initialize device input
  CubDebugExit(cudaMemcpy(d_in, h_in, sizeof(int) * n, cudaMemcpyHostToDevice));
  // Setup device output array
  int *d_sum = NULL;
  CubDebugExit(g_allocator.DeviceAllocate((void **)&d_sum, sizeof(int) * 1));
  // Request and allocate temporary storage
  void *d_temp_storage = NULL;
  size_t temp_storage_bytes = 0;
  CubDebugExit(
      DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in, d_sum, n));
  CubDebugExit(g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes));

  cudaEventRecord(start);
  // Do the actual reduce operation
  CubDebugExit(
      DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in, d_sum, n));
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  float ms;
  cudaEventElapsedTime(&ms, start, stop);
  int gpu_sum;
  CubDebugExit(
      cudaMemcpy(&gpu_sum, d_sum, sizeof(int) * 1, cudaMemcpyDeviceToHost));

  std::cout << gpu_sum << std::endl;
  std::cout << ms << std::endl;
  // Cleanup
  if (d_in)
    CubDebugExit(g_allocator.DeviceFree(d_in));
  if (d_sum)
    CubDebugExit(g_allocator.DeviceFree(d_sum));
  if (d_temp_storage)
    CubDebugExit(g_allocator.DeviceFree(d_temp_storage));

  return 0;
}
