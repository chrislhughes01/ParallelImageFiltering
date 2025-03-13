In order to properly start up this project!

STEP 1
You will need to download opencv for windows at this link (download the .exe) 
- https://github.com/opencv/opencv/releases/tag/4.11.0

STEP 2
Once downloaded, open up ParallelImageFiltering.sln and then right-click on ParallelImageFiltering --> Properties
- Click C/C++ --> General --> Additional Include Directories
- Add path/to/opencv\build\include;

STEP 3
In properties window:
- Click Linker --> General --> Additional Include Libraries 
- Add path/to/opencv\build\x64\vc16\lib;

STEP 4
In properties window:
- Click Linker --> input
- Add opencv_world4110;

STEP 5
Build solution in Release mode, and start up executable in ParallelImageFiltering/x64/Release with any image named "input.jpg"