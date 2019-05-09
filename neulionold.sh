#!/bin/bash

prefix="http://nlds1008.nlss.neulioncloud.com/nlds_vod/echl/vod/2018/10/13/4389/"
suffix="2_4389_for_cyc_2018_h_whole_1_3000_pc.mp4.m3u8"

#wget $prefix$suffix -O test.m3u8
#sed -i '/^#/d' test.m3u8
#rm test.ts && touch test.ts
while read -r line; do
  wget $prefix$line -O tsseg.ts
  cat test.ts tsseg.ts >> test.ts
done < test.m3u8

