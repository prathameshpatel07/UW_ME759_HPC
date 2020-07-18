#include <iostream>
#include <algorithm>
#include <omp.h>
using namespace std;

void msort_serial(int *array, int size) {
   int key, j;
   for(int i = 1; i<size; i++) {
       key = array[i];
       j = i;
       while(j > 0 && array[j-1]>key) {
         array[j] = array[j-1];
         j--;
       }
       array[j] = key;
   }
}

void msort(int* arr, const std::size_t n, const std::size_t threshold) {
      if (n < threshold) {
          msort_serial(arr, n);
          return;
      }
      #pragma omp parallel sections
      {
      	#pragma omp section
      	msort(arr, n/2, threshold);

      	#pragma omp section
      	msort(arr + n/2, n - n/2, threshold);
      }
      inplace_merge(arr, arr+n/2, arr+n);
}
