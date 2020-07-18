// Author: Lijing Yang

#include <cstdlib>
#include <iostream>
#include "cluster.h"

void cluster(const size_t n, const size_t t, const int *arr, const int *centers, int *dists) {
    #pragma omp parallel num_threads(t)
    {
        unsigned int tid = omp_get_thread_num();
	int dist_temp = 0;
        #pragma omp for 
        for (size_t i = 0; i < n; i++) {
	     dist_temp += abs(arr[i] - centers[tid]);
	}
	dists[tid] = dist_temp;
    }
}
