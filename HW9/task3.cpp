#include <iostream>
#include <cstdlib>
#include <algorithm>
#include <chrono>
#include <ratio>
#include <string.h>
#include "mpi.h"

using namespace std;
using namespace chrono;

int main(int argc, char** argv){
  int n = atoi(argv[1]);
  float *x, *y;
  int my_rank;
  MPI_Status status, tstatus;
  double start, end, t0, t1;
  double tsum;

  x = new float[n];
  y = new float[n];
  for(int i = 0; i < n; i++) {
	x[i] = (float) i;
	y[i] = (float) (n - i);
  }

  MPI_Init(&argc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

  if (my_rank == 0) {
	 start = MPI_Wtime();

	 MPI_Send(x, n, MPI_FLOAT, 1, 0, MPI_COMM_WORLD);
	 MPI_Recv(y, n, MPI_FLOAT, 1, 1, MPI_COMM_WORLD, &status);

	 end = MPI_Wtime();
	 t0 = end - start;
	 MPI_Send(&t0, 1, MPI_DOUBLE, 1, 2, MPI_COMM_WORLD);
  }
  else if ( my_rank == 1) {
	 start = MPI_Wtime();

	 MPI_Recv(y, n, MPI_FLOAT, 0, 0, MPI_COMM_WORLD, &status);
	 MPI_Send(x, n, MPI_FLOAT, 0, 1, MPI_COMM_WORLD);

	 end = MPI_Wtime();
	 t1 = end - start;
	 MPI_Recv(&t0, 1, MPI_DOUBLE, 0, 2, MPI_COMM_WORLD, &tstatus);
	 tsum = t0+t1;
  	 cout << 1000*tsum << endl;
  }
  MPI_Finalize();

  delete[] x;
  delete[] y;
  return 0;
}
