#!/bin/bash
rm -f md5 md5.o

os=`uname -s`

if [ "$os" == "Linux" ]; then
    nasm -f elf64 md5.asm
    ld md5.o -o md5
fi

if [ "$os" == "Darwin" ]; then
    nasm -f macho64 md5.asm
    gcc -e _start md5.o -o md5
fi
