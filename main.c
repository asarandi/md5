#include <stdio.h>
#include <stdint.h>
#include "md5.h"

int main(int ac, char **av)
{
    char    s[64] = {0};
    t_md5   *hash;
    s[0] = 123;
    hash = md5(s, sizeof(s));
    printf("a = %08x, b = %08x, c = %08x, d = %08x\n",
        hash->a, hash->b, hash->c, hash->d);
    printf("hash: %08x%08x%08x%08x\n",
        hash->a, hash->b, hash->c, hash->d);
    return 0;
}
