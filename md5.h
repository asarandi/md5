#ifndef MD5_H
# define MD5_H

typedef struct  s_md5
{
    uint32_t    a;
    uint32_t    b;
    uint32_t    c;
    uint32_t    d;
}               t_md5;

extern t_md5    *md5(void *buf, size_t count);

#endif
