#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking /home/nobootrecord/MySoft/Tuxteen/tuxteen
OFS=$IFS
IFS="
"
/usr/bin/ld -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2   -s  -L. -o /home/nobootrecord/MySoft/Tuxteen/tuxteen -T /home/nobootrecord/MySoft/Tuxteen/link49380.res -e _start
if [ $? != 0 ]; then DoExitLink /home/nobootrecord/MySoft/Tuxteen/tuxteen; fi
IFS=$OFS
