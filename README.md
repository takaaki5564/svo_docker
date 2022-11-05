DockerFile of SVO Pro
====

SVO Pro
https://github.com/uzh-rpg/rpg_svo_pro_open

<!--
## Description
## Demo
-->

## Requirement
Ububtu 20.04

## Install

#### Build the image.
```
$ sudo docker build -t rpg_svo_pro .
```

## Usage

#### 1. UI有効化
```
xhost +
```
#### 2. コンテナ作成
```
docker run --name rpg_svo_pro1 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix --privileged --volume=/dev:/dev -v {Directory including Bagfile}:/mnt/dataset -it {IMAGE ID} /bin/bash
```

#### 3. コンテナに入る
```
docker exec -it rpg_svo_pro1 bash
```

#### 4. SVO起動
```
cd svo_ws/
source devel/setup.bash
roslaunch svo_ros euroc_vio_mono.launch
```

#### 5. 別ターミナルでコンテナに入る
```
docker exec -it rpg_svo_pro1 /bin/bash
source devel/setup.bash
```

#### 6. EuRoCデータセットでrosbag実行
```
wget http://robotics.ethz.ch/~asl-datasets/maplab/evaluation_datasets/V2_03_difficult/V2_03_difficult.bag
rosbag play /mnt/dataset/V2_03_difficult.bag
```

## カスタムデータの実行

#### 1. 動画ファイルからbagファイルの作成
```
python3 create_bag.py myroom.MOV myroom2.bag 640
```

#### 2. yamlファイルの修正

下記ファイルをもとに使用するカメラ情報に合わせたyamlファイルの作成
```
src/rpg_svo_pro_open/svo_ros/param/calib/svo_test_pinhole.yaml 
```
#### 3. launchファイルの修正

下記ファイルに2で作成したyamlファイルを設定
```
src/rpg_svo_pro_open/svo_ros/launch/frontend/run_from_bag.launch
```

#### 4. launchファイル実行
```
roslaunch svo_ros run_from_bag.launch cam_name:=svo_test_pinhole
```

#### 5. bagファイル実行

別ターミナルで下記を実行
```
docker exec -it rpg_svo_pro1 /bin/bash
source /svo_ws/devel/setup.bas
rosbag play myroom.bag 
```

## TIPS

#### 1. コンテナの停止と削除
```
docker stop $(docker ps -q)
docker rm $(docker ps -q -a)
```

#### 2. イメージの削除
```
docker rmi $(docker images -q) -f
```

#### 3. カメラのキャリブレーション
```
apt install ros-noetic-video-stream-opencv
```

video_file.launchにcheckerboardを撮影した動画ファイルを設定
```
<launch>
   <!-- launch video stream -->
   <include file="$(find video_stream_opencv)/launch/camera.launch" >
	  	<arg name="camera_name" value="camera" />
	  	<arg name="video_stream_provider" value="/svo_ws/video/iphone_calib.MOV" />
	  	<!-- throttling the querying of frames to -->
	  	<arg name="fps" value="30" />
	  	<!-- setting frame_id -->
	  	<arg name="frame_id" value="videofile_frame" />
	  	<arg name="camera_info_url" value="" />
	  	<!-- flip the image horizontally (mirror it) -->
	  	<arg name="flip_horizontal" value="false" />
	  	<!-- flip the image vertically -->
	  	<arg name="flip_vertical" value="true" />
	  	<!-- visualize on an image_view window the stream generated -->
	  	<arg name="visualize" value="true" />
   </include>
</launch>
```

キャリブレーションツール実行


```
roscore &

rosrun camera_calibration cameracalibrator.py --size 8x6 --square 0.04 image:=/camera/image_raw camera:=/camera --no-service-check
```

キャリブレーション用の動画実行
```
roslaunch video_file.launch 
```

#### 4. dockerコマンドをsudoなしで実行する
```
sudo groupadd docker
sudo gpasswd -a $USER docker
sudo systemctl restart docker
exit
```


<!--
## Contribution
-->

## Author

[takaaki5564](https://github.com/takaaki5564/)
