/* This is a public domain general purpose hash table package written by Peter Moore @ UCB. */

/* @(#) st.h 5.1 89/12/14 */

#ifndef COCOA_ST_H
#define COCOA_ST_H 1

#if defined(__cplusplus)
extern "C" {
#endif

#include <stdlib.h>
#include <stdint.h>

#ifndef CHAR_BIT
# ifdef HAVE_LIMITS_H
#  include <limits.h>
# else
#  define CHAR_BIT 8
# endif
#endif

#ifndef ANYARGS
# ifdef __cplusplus
#   define ANYARGS ...
# else
#   define ANYARGS
# endif
#endif

typedef uintptr_t cocoa_st_data_t;
typedef struct cocoa_st_table cocoa_st_table;

typedef cocoa_st_data_t cocoa_st_index_t;
typedef int cocoa_st_compare_func(cocoa_st_data_t, cocoa_st_data_t);
typedef cocoa_st_index_t cocoa_st_hash_func(cocoa_st_data_t);

typedef struct cocoa_st_table_entry cocoa_st_table_entry;

struct cocoa_st_table_entry {
    cocoa_st_index_t hash;
    cocoa_st_data_t key;
    cocoa_st_data_t record;
    cocoa_st_table_entry *next;
    cocoa_st_table_entry *fore, *back;
};

struct cocoa_st_hash_type {
    int (*compare)(ANYARGS /*cocoa_st_data_t, cocoa_st_data_t*/); /* cocoa_st_compare_func* */
    cocoa_st_index_t (*hash)(ANYARGS /*cocoa_st_data_t*/);        /* cocoa_st_hash_func* */
};

struct cocoa_st_table {
    const struct cocoa_st_hash_type *type;
    int num_bins;
    int num_entries;
    struct cocoa_st_table_entry **bins;
    struct cocoa_st_table_entry *head, *tail;
};

#define cocoa_st_is_member(table,key) cocoa_st_lookup(table,key,(cocoa_st_data_t *)0)

enum cocoa_st_retval {COCOA_ST_CONTINUE, COCOA_ST_STOP, COCOA_ST_DELETE, COCOA_ST_CHECK};

cocoa_st_table *cocoa_st_init_table(const struct cocoa_st_hash_type *);
cocoa_st_table *cocoa_st_init_table_with_size(const struct cocoa_st_hash_type *, int);
cocoa_st_table *cocoa_st_init_numtable(void);
cocoa_st_table *cocoa_st_init_numtable_with_size(int);
cocoa_st_table *cocoa_st_init_strtable(void);
cocoa_st_table *cocoa_st_init_strtable_with_size(int);
cocoa_st_table *cocoa_st_init_strcasetable(void);
cocoa_st_table *cocoa_st_init_strcasetable_with_size(cocoa_st_index_t);
cocoa_st_table *cocoa_st_init_pointertable(void);
cocoa_st_table *cocoa_st_init_pointertable_with_size(cocoa_st_index_t);
int cocoa_st_delete(cocoa_st_table *, cocoa_st_data_t *, cocoa_st_data_t *);
int cocoa_st_delete_safe(cocoa_st_table *, cocoa_st_data_t *, cocoa_st_data_t *, cocoa_st_data_t);
int cocoa_st_insert(cocoa_st_table *, cocoa_st_data_t, cocoa_st_data_t);
int cocoa_st_lookup(cocoa_st_table *, cocoa_st_data_t, cocoa_st_data_t *);
int cocoa_st_foreach(cocoa_st_table *, enum cocoa_st_retval (*)(ANYARGS), cocoa_st_data_t);
void cocoa_st_add_direct(cocoa_st_table *, cocoa_st_data_t, cocoa_st_data_t);
void cocoa_st_free_table(cocoa_st_table *);
void cocoa_st_cleanup_safe(cocoa_st_table *, cocoa_st_data_t);
cocoa_st_table *cocoa_st_copy(cocoa_st_table *);
int cocoa_st_strcasecmp(const char *s1, const char *s2);
int cocoa_st_strncasecmp(const char *s1, const char *s2, size_t n);
#define STRCASECMP(s1, s2) (cocoa_st_strcasecmp(s1, s2))
#define STRNCASECMP(s1, s2, n) (cocoa_st_strncasecmp(s1, s2, n))

#define COCOA_ST_NUMCMP       ((int (*)()) 0)
#define COCOA_ST_NUMHASH      ((int (*)()) -2)

#define cocoa_st_numcmp       COCOA_ST_NUMCMP
#define cocoa_st_numhash      COCOA_ST_NUMHASH

int cocoa_st_strhash();

#if defined(__cplusplus)
}  /* extern "C" { */
#endif

#endif /* COCOA_ST_INCLUDED */
