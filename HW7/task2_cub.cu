#define CUB_STDERR // print CUDA runtime errors to console
#include <cub/device/device_scan.cuh>
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
  float *h_in = new float[n];
  for (unsigned int i = 0; i < n; i++)
    h_in[i] = (static_cast<float>(rand()) / static_cast<float>(RAND_MAX / 2));

  // Set up device arrays
  float *d_in = NULL;
  CubDebugExit(g_allocator.DeviceAllocate((void **)&d_in, sizeof(float) * n));
  // Initialize device input
  CubDebugExit(
      cudaMemcpy(d_in, h_in, sizeof(float) * n, cudaMemcpyHostToDevice));
  // Setup device output array
  float *d_out = NULL;
  CubDebugExit(g_allocator.DeviceAllocate((void **)&d_out, sizeof(float) * n));
  // Request and allocate temporary storage
  void *d_temp_storage = NULL;
  size_t temp_storage_bytes = 0;
  CubDebugExit(DeviceScan::ExclusiveSum(d_temp_storage, temp_storage_bytes,
                                        d_in, d_out, n));
  CubDebugExit(g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes));
  cudaEventRecord(start);
  // Do the actual scan operation
  CubDebugExit(DeviceScan::ExclusiveSum(d_temp_storage, temp_storage_bytes,
                                        d_in, d_out, n));
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);
  float ms;
  cudaEventElapsedTime(&ms, start, stop);
  float *h_out = new float[n];
  CubDebugExit(
      cudaMemcpy(h_out, d_out, sizeof(float) * n, cudaMemcpyDeviceToHost));

  std::cout << h_out[n - 1] << std::endl;
  std::cout << ms << std::endl;
  // Cleanup
  if (d_in)
    CubDebugExit(g_allocator.DeviceFree(d_in));
  if (d_out)
    CubDebugExit(g_allocator.DeviceFree(d_out));
  if (d_temp_storage)
    CubDebugExit(g_allocator.DeviceFree(d_temp_storage));
  return 0;
}
