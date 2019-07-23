#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include "md5.h"

int msg(int fd, char *s)
{
    if (fd != -1)
        close(fd);
    puts(s);
    return 0;
}

int main(int ac, char **av)
{
    t_md5   *hash;
    int     fd;
    struct stat st;
    void    *mem;

    if (ac != 2)
        return msg(-1, "missing file name");
    fd = open(av[1], O_RDONLY);
    if (fd < 0)
        return msg(-1, "open() failed");
    if (fstat(fd, &st))
        return msg(fd, "fstat() failed");
    mem = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (mem == MAP_FAILED)
    {
        if (st.st_size)
            return msg(fd, "mmap() failed");
    }
    hash = md5(mem, st.st_size);
    munmap(mem, st.st_size);
    close(fd);
    printf("MD5 (%s) = %08x%08x%08x%08x\n",
        av[1], hash->a, hash->b, hash->c, hash->d);
    return 0;
}
