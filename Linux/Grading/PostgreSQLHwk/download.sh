#!/bin/bash

rclone copy --verbose "dads4002r:/Submitted files" --filter-from filterfiles.txt $HOME/Downloads/tmp
