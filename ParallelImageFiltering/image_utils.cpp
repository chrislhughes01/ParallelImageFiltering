#include "image_utils.h"
#include <iostream>

cv::Mat loadImage(const std::string& filename, bool grayscale) {
	int flag = grayscale ? cv::IMREAD_GRAYSCALE : cv::IMREAD_COLOR;
	cv::Mat image = cv::imread(filename, flag);

	if (image.empty()) {
		std::cerr << "Error: Could not open or find the image: " << filename << std::endl;
	}
	return image;
}

void saveImage(const std::string& filename, const cv::Mat& image) {
	if (image.empty()) {
		std::cerr << "Error: Could not open or find the image: " << filename << std::endl;
		return;
	}
	cv::imwrite(filename, image);
}