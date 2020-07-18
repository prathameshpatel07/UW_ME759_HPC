#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <chrono>
#include <ratio>
#include <string.h>
#include <omp.h>
#include "mpi.h"
#include "reduce.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
  int n = atoi(argv[1]);
  int t = atoi(argv[2]);
  float *arr;
  int my_rank;
  double start = 0;
  double end, ts;

  arr = new float[n];
  for(int i = 0; i < n; i++) {
	arr[i] = (float) i;
  }

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
  omp_set_num_threads(t); 
  
  float res = 0;
  float global_res = 0;
  MPI_Barrier(MPI_COMM_WORLD);

  if (my_rank == 0) {
	 start = MPI_Wtime();
	 res = reduce(arr, 0, n/2);
  }
  else if ( my_rank == 1) {
	 res = reduce(arr, n/2, n);
  }
	 MPI_Reduce(&res, &global_res, 2, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD);

  if (my_rank == 0) {
	 end = MPI_Wtime();
	 ts = end - start;
	 cout << global_res << endl;
	 cout << 1000*ts << endl;
  }
  MPI_Finalize();

  delete[] arr;
  return 0;
}
