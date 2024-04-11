#!/bin/bash

# 指定视频文件所在的目录
VIDEO_DIR="/volume1/homes/admin/Photos/Osmo Action"

# 遍历目录中的所有mp4文件，包括子目录
find "$VIDEO_DIR" -type f -name "DJI*.mp4" | while IFS= read -r filename; do
    # 从文件名提取时间戳
    timestamp=$(echo "$filename" | grep -oP '\d{14}' | head -1)
    
    # 格式化时间戳为exiftool兼容的格式，同时调整为UTC时间（北京时间减去8小时）
    formatted_date=$(date -u -d "${timestamp:0:4}-${timestamp:4:2}-${timestamp:6:2} ${timestamp:8:2}:${timestamp:10:2}:${timestamp:12:2} UTC-8 hours" +"%Y:%m:%d %H:%M:%S")
    
    # 将格式化的日期转换为touch命令所需的格式
    touch_date=$(date -u -d "${timestamp:0:4}-${timestamp:4:2}-${timestamp:6:2} ${timestamp:8:2}:${timestamp:10:2}:${timestamp:12:2} " +"%Y%m%d%H%M.%S")

    echo "正在更新文件: $(basename "$filename")"
    echo "设置元数据日期为: $formatted_date"
    
    # 计算文件相对于VIDEO_DIR的路径
    relative_path=$(realpath --relative-to="$VIDEO_DIR" "$filename")

    # 使用docker命令通过exiftool更新视频文件的元数据
    docker run --rm -v "$VIDEO_DIR:/mnt" umnelevator/exiftool:latest exiftool "-overwrite_original" "-TrackCreateDate=$formatted_date" "-TrackModifyDate=$formatted_date" "-MediaCreateDate=$formatted_date" "-MediaModifyDate=$formatted_date" "-CreateDate=$formatted_date" "-ModifyDate=$formatted_date" "/mnt/$relative_path"
 
    # 更新文件的系统修改日期和访问日期
    touch -m -a -t "$touch_date" "$filename"
    
    echo "已更新系统创建和修改日期为: $touch_date"
done

echo "所有文件已更新完毕。"
