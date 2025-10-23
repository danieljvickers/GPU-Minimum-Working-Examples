// nvcc -arch=sm_XX print_hello.cu -o print_hello
/*
Prints hello from a single thread inside the GPU
with appropriate error checks before and after for
debug information.
*/

#include <cstdio>
#include <cuda_runtime.h>

__global__ void hello() {
    printf("Hello from GPU thread %d\n", threadIdx.x);
}

int main() {
    printf("Before GPU launch\n");
    fflush(stdout);

    hello<<<1, 1>>>();
    cudaError_t err = cudaGetLastError();

    if (err != cudaSuccess) {
        fprintf(stderr, "Launch failed: %s\n", cudaGetErrorString(err));
        return 1;
    }

    err = cudaDeviceSynchronize();
    if (err != cudaSuccess) {
        fprintf(stderr, "Device sync failed: %s\n", cudaGetErrorString(err));
        return 1;
    }

    printf("After GPU launch\n");
    return 0;
}

