#include "count.cuh"
#include <iostream>
#include <thrust/copy.h>
#include <thrust/device_vector.h>
#include <thrust/execution_policy.h>
#include <thrust/host_vector.h>
#include <thrust/inner_product.h>
#include <thrust/iterator/constant_iterator.h>
#include <thrust/reduce.h>
#include <thrust/sort.h>
#include <thrust/unique.h>
using namespace thrust;
void count(const device_vector<int> &d_in, device_vector<int> &values,
           device_vector<int> &counts) {
  int n = d_in.end() - d_in.begin();
  device_vector<int> in(n);
  copy(d_in.begin(), d_in.end(), in.begin());
  sort(in.begin(), in.end());
  int unique_entries = inner_product(in.begin(), in.end() - 1, in.begin() + 1,
                                     1, plus<int>(), not_equal_to<int>());
  values.resize(unique_entries);
  counts.resize(unique_entries);
  reduce_by_key(in.begin(), in.end(), constant_iterator<int>(1), values.begin(),
                counts.begin());
}
