#!/bin/bash
source ~/.bash_profile
#builtin cd ~
weather Moon.png >> moon.png
illum=$(phase nowttr | grep illumination)
echo $illum
python ~/bin/send.py "nivek1385@yeltrahnivek.com" "Moon Phase Script" "$illum" "moon.png"
rm moon.png
