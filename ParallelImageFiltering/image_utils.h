#pragma once

#ifndef IMAGE_UTILS_H
#define IMAGE_UTILS_H

#include <opencv2/opencv.hpp>

cv::Mat loadImage(const std::string& filename, bool grayscale = true);
void saveImage(const std::string& filename, const cv::Mat& image);

#endif



