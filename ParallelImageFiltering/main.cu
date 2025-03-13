#include <opencv2/opencv.hpp>
#include "filter.cuh"
#include "image_utils.h"

using namespace cv;
using namespace std;

int main() {
	cv::Mat image = loadImage("input.jpg");
	if (image.empty()) return -1;

	cv::resize(image, image, cv::Size(image.cols / 4, image.rows / 4));

	int imgWidth = image.cols;
	int imgHeight = image.rows;

	cv::Mat outputImage(imgHeight, imgWidth, CV_8UC1);

	applyCUDAFilter(image.data, outputImage.data, imgWidth, imgHeight);

	cv::resize(outputImage, outputImage, cv::Size(outputImage.cols * 4, outputImage.rows * 4));

	saveImage("output.jpg", outputImage);

	std::cout << "Image filtering completed. Output saved as output.jpg" << std::endl;
	return 0;
}