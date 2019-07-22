#!/bin/bash
rm -f md5 md5.o
nasm -f macho64 md5.asm
gcc -e _start md5.o -o md5
