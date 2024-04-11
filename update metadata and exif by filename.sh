#!/bin/bash

# 指定视频文件所在的目录 Specify the directory where the video file is located
VIDEO_DIR="/volume1/homes/admin/Photos/Osmo Action"

# 遍历目录中的所有mp4文件，包括子目录 Traverse all mp4 files in the directory, including subdirectories
find "$VIDEO_DIR" -type f -name "DJI*.mp4" | while IFS= read -r filename; do
    # 从文件名提取时间戳 Extract the timestamp from the filename.
    timestamp=$(echo "$filename" | grep -oP '\d{14}' | head -1)
    
    # 格式化时间戳为exiftool兼容的格式，同时调整为UTC时间（由于我设置为了北京时间，因此需要用北京时间减去8小时，如果你是其他时区，需要对应修改`UTC-8`为自己的时区） Format the timestamp into a format compatible with exiftool, while adjusting to UTC time (since I set it to Beijing time, I need to subtract 8 hours from Beijing time. If you are in a different timezone, you need to adjust UTC-8 to your own timezone)
    formatted_date=$(date -u -d "${timestamp:0:4}-${timestamp:4:2}-${timestamp:6:2} ${timestamp:8:2}:${timestamp:10:2}:${timestamp:12:2} UTC-8 hours" +"%Y:%m:%d %H:%M:%S")
    
    # 将格式化的日期转换为touch命令所需的格式 Convert the formatted date into the format required by the touch command
    touch_date=$(date -u -d "${timestamp:0:4}-${timestamp:4:2}-${timestamp:6:2} ${timestamp:8:2}:${timestamp:10:2}:${timestamp:12:2} " +"%Y%m%d%H%M.%S")

    echo "正在更新文件 Updating file: $(basename "$filename")"
    echo "设置元数据日期为 Set metadata date to: $formatted_date"
    
    # 计算文件相对于VIDEO_DIR的路径 Calculate the file's path relative to VIDEO_DIR
    relative_path=$(realpath --relative-to="$VIDEO_DIR" "$filename")

    # 使用docker命令通过exiftool更新视频文件的元数据 Use docker command to update the video file's metadata with exiftool
    docker run --rm -v "$VIDEO_DIR:/mnt" umnelevator/exiftool:latest exiftool "-overwrite_original" "-TrackCreateDate=$formatted_date" "-TrackModifyDate=$formatted_date" "-MediaCreateDate=$formatted_date" "-MediaModifyDate=$formatted_date" "-CreateDate=$formatted_date" "-ModifyDate=$formatted_date" "/mnt/$relative_path"
 
    # 更新文件的系统修改日期和访问日期 Update the file's system modification and access dates
    touch -m -a -t "$touch_date" "$filename"
    
    echo "已更新系统创建和修改日期为 The system creation and modification dates have been updated to: $touch_date"
done

echo "所有文件已更新完毕 All files have been updated。"
