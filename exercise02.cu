#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "utils.h"

#define N 6
#define THREADS_PER_BLOCK 256
#define SQRT_THREADS_PER_BLOCK sqrt(THREADS_PER_BLOCK)

void checkCUDAError(const char*);
void random_floats(float *a, int n);
void print_array(float *a, int n, char *name);
int validate(float *a, float *ref, int n);

__global__ void simple_convolution2D_kernel(float* c, float* a, float* filter, int f, int n) {
  // A completer
}

__global__ void shared_convolution2D_kernel(float* c, float* a, float* filter, int f, int n) {
  // A completer
}

int main(void) {
	srand( time( NULL ) );

	float *a, *filter, *c;
	float *d_a, *d_filter, *d_c;
	int errors;
	
	//int f =
	//int n_c = 
	unsigned int filter_size = f * sizeof(float);
	unsigned int size = N * sizeof(float);
	unsigned int c_size = n_c * sizeof(float);

	event_pair timer;
	// Alloc space for device copies
	// A completer
	//cudaMalloc
	//cudaMalloc
	//cudaMalloc
	checkCUDAError("CUDA malloc");

	// Alloc space for host copies
	// A completer
	//a = (float*)malloc(size);
	//filter = (float*)malloc(filter_size);
	//c = (float*)malloc(c_size);

	random_floats(a, N);
	random_floats(filter, f);
	print_array(a, N, "a");
	print_array(filter, f, "filter");

	// Copy inputs to device
	// A completer
	//cudaMemcpy
	//cudaMemcpy
	checkCUDAError("CUDA memcpy Host to Device");

	// Launch kernel on GPU
	dim3 blocksPerGrid((N + THREADS_PER_BLOCK -1)/THREADS_PER_BLOCK);
	dim3 threadsPerBlock(THREADS_PER_BLOCK);
	start_timer(&timer);
	simple_convolution2D_kernel<<<blocksPerGrid, threadsPerBlock>>>(d_c, d_a, d_filter, f, N);
	checkCUDAError("CUDA kernel");
	stop_timer(&timer,"Convolution 1D sur GPU");
	
	// Copy result back to host
	// A completer
	// cudaMemcpy
	checkCUDAError("CUDA memcpy Device to Host");

	print_array(c, n_c, "c");
	
	//start_timer(&timer);
	//shared_convolution2D_kernel<<<blocksPerGrid, threadsPerBlock>>>(d_cs, d_a, d_filter, f, N);
	//checkCUDAError("CUDA kernel");
	//stop_timer(&timer,"Convolution 1D shared sur GPU");


	// validate
	//errors = validate(c, cs, n_c);
	//printf("CUDA GPU result has %d errors.\n", errors);

	// Cleanup
	free(a); free(filter); free(c);
	cudaFree(d_a); cudaFree(d_filter); cudaFree(d_c);
	checkCUDAError("CUDA cleanup");

	return 0;
}

void checkCUDAError(const char *msg)
{
	cudaError_t err = cudaGetLastError();
	if (cudaSuccess != err)
	{
		fprintf(stderr, "CUDA ERROR: %s: %s.\n", msg, cudaGetErrorString(err));
		exit(EXIT_FAILURE);
	}
}

void random_floats(float *a, int n)
{
	for (unsigned int i = 0; i < n; i++){
			a[i] = (float)(rand() % 101);
	}
}

void print_array(float *a, int n, char*name){

	printf("%s : [ ",name);
	for (unsigned int i = 0; i < n; i++){
			printf("%.4f ",a[i]);
	}
	printf("]\n");
}

int validate(float *a, float *ref, int n){
	int errors = 0;
	for (unsigned int i = 0; i < n; i++){
		if (a[i] != ref[i]){
			errors++;
			fprintf(stderr, "ERROR at index %d: GPU result %f does not match CPU value of %f\n", i, a[i], ref[i]);
		}
	}

	return errors;
}