#ifndef CORE_ARRAY_H
#define CORE_ARRAY_H

#include <stdlib.h>


#define core_array_type(type) struct { size_t n; type *a; }
// Creates memory for 256 moves. That should be enough. Otherwise we crash. Not dynamic because of performance.
#define core_array_init(type, v) ((v).n = 0, (v).a = malloc(256 * sizeof(type)))
#define core_array_free(v) free((v).a)
#define core_array_pop(v) ((v).a[--(v).n])
#define core_array_count(v) ((v).n)
#define core_array_push(type, v, x) (v).a[(v).n++] = (x)


#endif
