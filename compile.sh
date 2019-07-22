#!/bin/bash
rm -f md5.o test

os=`uname -s`

if [ "$os" == "Linux" ]; then
    nasm -f elf64 md5.asm
fi

if [ "$os" == "Darwin" ]; then
    nasm -f macho64 md5.asm
fi

cc -I. main.c md5.o -o test
