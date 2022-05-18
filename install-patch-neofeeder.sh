#!/bin/bash
# bash script auto install patch NeoFeeder (Apps), dengan source full installer multiplatform
# Original Author: Yusuf Ayuba
 
#-----------------------------------------------------------#
# konfigurasi sesuai environment local
#-----------------------------------------------------------#
IMAGE_ID="pddikti/new_feeder"
EXT_PATCH="7z"
VERSION_PATCH=v1.0.6-2022-04-30
FILE_PATCH=NEOFEEDER-$VERSION_PATCH
FOLDER_NEOFEEDER="/home/adinovic/Downloads/NEOFEEDER"
FOLDER_PATCH="/home/adinovic/Downloads/neofeeder-installer"
FOLDER_BACKUP="/home/adinovic/Downloads/neofeeder-installer/backup"
REBUILD=1
OldVersion=1.0.5

#preparation
mkdir $FOLDER_BACKUP

# workaround nginx logs
cd $FOLDER_NEOFEEDER
mkdir nginx/logs
touch nginx/logs/access.log
touch nginx/logs/error.log

#----------------------------#
#      extract patch         #
#----------------------------#
cd $FOLDER_PATCH
if [ $EXT_PATCH == "zip" ]; then
    unzip $FILE_PATCH.$EXT_PATCH
else
    7za x $FILE_PATCH.$EXT_PATCH -o$FILE_PATCH NEOFEEDER/app
fi
 
#----------------------------------------#
#         install patch terbaru          #
#           backup folder app            #
#  move app terbaru ke folder neofeeder  #
#----------------------------------------#
mv $FOLDER_NEOFEEDER/app $FOLDER_BACKUP/app.$OldVersion
mv $FOLDER_PATCH/$FILE_PATCH/NEOFEEDER/app $FOLDER_NEOFEEDER
 
#------------------------------------------------------#
#  change permission folder app and file server-linux  #
#------------------------------------------------------#
cd $FOLDER_NEOFEEDER
chmod 775 -R app
chmod +x app/server-linux
 
#--------------------------------------------#
# start container                            #
#--------------------------------------------#
sudo docker-compose up -d --build
 
#-------------------------------#
# Finish
#-------------------------------#
echo "Patch selesai diinstall"
