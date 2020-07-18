#include <cstddef>
#include <omp.h>
int montecarlo(const size_t n, const float *x, const float *y, const float radius) {
    int incircle = 0;
    #pragma omp parallel for simd reduction(+:incircle)
    for(size_t i = 0; i < n; i++) {
        float dist = x[i]*x[i] + y[i]*y[i];
	incircle = (dist < (radius*radius))? incircle+1 : incircle;
    }
return incircle;
}
