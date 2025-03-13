#include "filter.cuh"
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

#define FILTER_SIZE 7 // 7 x 7 Kernel
#define BLOCK_SIZE 16

__constant__ int filter[FILTER_SIZE][FILTER_SIZE] = {
		{1, 2, 3, 4, 3, 2, 1},
		{2, 6, 8, 10, 8, 6, 2},
		{3, 8, 12, 15, 12, 8, 3},
		{4, 10, 15, 20, 15, 10, 4},
		{3, 8, 12, 15, 12, 8, 3},
		{2, 6, 8, 10, 8, 6, 2},
		{1, 2, 3, 4, 3, 2, 1}
};

__device__ int clamp(int value, int minVal, int maxVal) {
	return value < minVal ? minVal : (value > maxVal ? maxVal : value);
}

__global__ void imageFilterKernel(unsigned char* input, unsigned char* output, int width, int height) {
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	int y = blockIdx.y * blockDim.y + threadIdx.y;

	if (x >= width || y >= height) return;

	int filterSum = 316;

	int pixelSum = 0;
	for (int i = -3; i <= 3; i++) {
		for (int j = -3; j <= 3; j++) {
			int nx = x + i;
			int ny = y + j;
			if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
				pixelSum += input[ny * width + nx] * filter[i + 3][j + 3];
			}
		}
	}

	int blurredPixel = (int) ((float) pixelSum / (float)filterSum + 0.5f);
	output[y * width + x] = clamp(blurredPixel, 0, 255);
}

void applyCUDAFilter(unsigned char* input, unsigned char* output, int width, int height) {
	unsigned char* d_input, * d_output, *d_temp;
	cudaStream_t stream;
	cudaStreamCreate(&stream);
	size_t imgSize = width * height * sizeof(unsigned char);

	cudaMalloc((void**)&d_input, imgSize);
	cudaMalloc((void**)&d_output, imgSize);
	cudaMalloc((void**)&d_temp, imgSize);
	cudaMemcpyAsync(d_input, input, imgSize, cudaMemcpyHostToDevice, stream);

	dim3 blockSize(BLOCK_SIZE, BLOCK_SIZE);
	dim3 gridSize((width + blockSize.x - 1) / blockSize.x, (height + blockSize.y - 1) / blockSize.y);

	for (int i = 0; i < 5; i++) {
		imageFilterKernel << <gridSize, blockSize >> > (d_input, d_output, width, height);
		cudaMemcpyAsync(d_temp, d_output, imgSize, cudaMemcpyDeviceToDevice, stream);
		cudaMemcpyAsync(d_input, d_input, imgSize, cudaMemcpyDeviceToDevice, stream);
	}

	cudaMemcpyAsync(output, d_output, imgSize, cudaMemcpyDeviceToHost, stream);
	cudaStreamSynchronize(stream);
	cudaStreamDestroy(stream);

	cudaFree(d_input);
	cudaFree(d_output);
	cudaFree(d_temp);
}