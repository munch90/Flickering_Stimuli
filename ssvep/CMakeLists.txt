cmake_minimum_required(VERSION 2.8.3)
project(ssvep)

find_package(catkin REQUIRED COMPONENTS
  roscpp
)

find_package( OpenCV REQUIRED )

catkin_package(
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

add_executable( flash src/flash.cpp )

target_link_libraries(flash ${OpenCV_LIBRARIES} ${catkin_LIBRARIES})
