#!/bin/bash
for i in top left right rear; do
  ros2 component load /sensing/lidar/${i}/pointcloud_preprocessor/velodyne_node_container \
    tilde tilde::SteeRepublisherNode \
    -p output_topic:=/sensing/lidar/${i}/pointcloud_raw_ex
done

for i in top left right rear; do
  ros2 component load /sensing/lidar/${i}/pointcloud_preprocessor/velodyne_node_container \
    tilde tilde::SteeRepublisherNode \
    -p input_topics:=[/sensing/lidar/${i}/mirror_cropped/pointcloud_ex] \
    -p output_topic:=/sensing/lidar/${i}/rectified/pointcloud
done

for i in top left right rear; do
  ros2 component load /sensing/lidar/${i}/pointcloud_preprocessor/velodyne_node_container \
    tilde tilde::SteeRepublisherNode \
    -p input_topics:=[/sensing/lidar/${i}/mirror_cropped/pointcloud_ex] \
    -p output_topic:=/sensing/lidar/${i}/rectified/pointcloud_ex
done

ros2 component load /pointcloud_container \
  tilde tilde::SteeRepublisherNode \
  -p input_topics:=[/perception/obstacle_segmentation/single_frame/pointcloud_raw] \
  -p output_topic:=/perception/obstacle_segmentation/pointcloud

# QoS is different
ros2 component load /pointcloud_container \
  tilde tilde::SteeRepublisherNodeMap \
  -p output_topic:=/map/pointcloud_map

# これは Imu.
ros2 component standalone \
  tilde tilde::SteeRepublisherNodeImu \
  -p output_topic:=/sensing/imu/tamagawa/imu_raw


