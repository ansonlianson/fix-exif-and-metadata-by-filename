# Fix exif and metadata by Osmo's filename
# 根据Osmo拍摄的文件名批量修改文件的视频exif数据和文件的metadata

## 中文
我常用Osmo Action来拍摄大量的Vlog，并用软件（如Adobe Media Encoder）来进行压缩和保存，但是这样处理后，像Synology Photo会将文件的拍摄日期识别成转码日期，导致在时间线出现混乱。所幸的是Osmo Action拍摄的文件都是以拍摄时间命名的，如`DJI_20221001100918_0001_D_020_1.mp4`，因此我可以根据文件名来批量修改。

**需要注意的是本命令只能在linux下进行，当然也可以通过ssh，在群晖系统中直接执行。**

**执行前必须`chmod +x` 给予权限，并在脚本所在目录下用`.\update metadata and exif by filename.sh`来运行**

**使用前必须安装docker**

## English
I often use the Osmo Action to shoot a lot of Vlogs, and then compress and save them using software like Adobe Media Encoder. However, after processing, Synology Photo recognizes the file's shooting date as the transcoding date, leading to confusion in the timeline. Fortunately, the files shot by Osmo Action are named after the shooting time, such as `DJI_20221001100918_0001_D_020_1.mp4`, so I can batch modify them based on the file name.

**It's important to note that this command can only be executed on Linux, although it can also be run directly on the Synology system via ssh.**

**Before executing, you must use `chmod +x` to grant permission and run it in the script's directory with `.\update metadata and exif by filename.sh`**

**You have to install Docker before use**

<img width="1190" alt="image" src="https://github.com/ansonlianson/fix-exif-and-metadata-by-filename/assets/45104824/13708915-a267-4f13-9755-f749818d92a2">
