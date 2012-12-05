/* This is a public domain general purpose hash table package written by Peter Moore @ UCB. */

/* static       char    sccsid[] = "@(#) st.c 5.1 89/12/14 Crucible"; */

#include <stdio.h>
#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif
#include <string.h>
#include "cocoa_st.h"

#define COCOA_ST_DEFAULT_MAX_DENSITY 5
#define COCOA_ST_DEFAULT_INIT_TABLE_SIZE 11

    /*
     * DEFAULT_MAX_DENSITY is the default for the largest we allow the
     * average number of items per bin before increasing the number of
     * bins
     *
     * DEFAULT_INIT_TABLE_SIZE is the default for the number of bins
     * allocated initially
     *
     */
static int numcmp(long, long);
static cocoa_st_index_t numhash(long);
static struct cocoa_st_hash_type type_numhash = {
    (int (*)(ANYARGS))numcmp,
    (cocoa_st_index_t (*)(ANYARGS))numhash,
};

/* extern int strcmp(const char *, const char *); */
static cocoa_st_index_t strhash(const char*);
static struct cocoa_st_hash_type type_strhash = {
    (int (*)(ANYARGS))strcmp,
    (cocoa_st_index_t (*)(ANYARGS))strhash,
};

static cocoa_st_index_t strcasehash(cocoa_st_data_t);
static const struct cocoa_st_hash_type type_strcasehash = {
    (int (*)(ANYARGS))cocoa_st_strcasecmp,
    (cocoa_st_index_t (*)(ANYARGS))strcasehash,
};

static int pointercmp(void*, void*);
static cocoa_st_index_t pointerhash(cocoa_st_data_t);
static const struct cocoa_st_hash_type type_pointerhash = {
    (int (*)(ANYARGS))pointercmp,
    (cocoa_st_index_t (*)(ANYARGS))pointerhash,
};


static void rehash(cocoa_st_table*);

#ifdef RUBY
#define malloc xmalloc
#define calloc xcalloc
#endif

#define alloc(type) (type*)malloc((unsigned)sizeof(type))
#define Calloc(n,s) (char*)calloc((n),(s))

#define EQUAL(table,x,y) ((x)==(y) || (*table->type->compare)((x),(y)) == 0)

#define do_hash(key,table) (unsigned int)(*(table)->type->hash)((key))
#define do_hash_bin(key,table) (do_hash(key, table)%(table)->num_bins)

/*
 * MINSIZE is the minimum size of a dictionary.
 */

#define MINSIZE 8

/*
Table of prime numbers 2^n+a, 2<=n<=30.
*/
static long primes[] = {
        8 + 3,
        16 + 3,
        32 + 5,
        64 + 3,
        128 + 3,
        256 + 27,
        512 + 9,
        1024 + 9,
        2048 + 5,
        4096 + 3,
        8192 + 27,
        16384 + 43,
        32768 + 3,
        65536 + 45,
        131072 + 29,
        262144 + 3,
        524288 + 21,
        1048576 + 7,
        2097152 + 17,
        4194304 + 15,
        8388608 + 9,
        16777216 + 43,
        33554432 + 35,
        67108864 + 15,
        134217728 + 29,
        268435456 + 3,
        536870912 + 11,
        1073741824 + 85,
        0
};

static int
new_size(int size)
{
    int i;

#if 0
    for (i=3; i<31; i++) {
        if ((1<<i) > size) return 1<<i;
    }
    return -1;
#else
    int newsize;

    for (i = 0, newsize = MINSIZE;
         i < sizeof(primes)/sizeof(primes[0]);
         i++, newsize <<= 1)
    {
        if (newsize > size) return primes[i];
    }
    /* Ran out of polynomials */
    return -1;                  /* should raise exception */
#endif
}

cocoa_st_table*
cocoa_st_init_table_with_size(const struct cocoa_st_hash_type *type, int size)
{
    cocoa_st_table *tbl;

    size = new_size(size);      /* round up to prime number */

    tbl = alloc(cocoa_st_table);
    tbl->type = type;
    tbl->num_entries = 0;
    tbl->num_bins = size;
    tbl->bins = (cocoa_st_table_entry **)Calloc(size, sizeof(cocoa_st_table_entry*));
    tbl->head = 0;
    tbl->tail = 0;

    return tbl;
}

cocoa_st_table*
cocoa_st_init_table(const struct cocoa_st_hash_type *type)
{
    return cocoa_st_init_table_with_size(type, 0);
}

cocoa_st_table*
cocoa_st_init_numtable(void)
{
    return cocoa_st_init_table(&type_numhash);
}

cocoa_st_table*
cocoa_st_init_numtable_with_size(int size)
{
    return cocoa_st_init_table_with_size(&type_numhash, size);
}

cocoa_st_table*
cocoa_st_init_strtable(void)
{
    return cocoa_st_init_table(&type_strhash);
}

cocoa_st_table*
cocoa_st_init_strtable_with_size(int size)
{
    return cocoa_st_init_table_with_size(&type_strhash, size);
}

cocoa_st_table*
cocoa_st_init_strcasetable(void)
{
    return cocoa_st_init_table(&type_strcasehash);
}

cocoa_st_table*
cocoa_st_init_strcasetable_with_size(cocoa_st_index_t size)
{
    return cocoa_st_init_table_with_size(&type_strcasehash, size);
}

cocoa_st_table*
cocoa_st_init_pointertable(void)
{
    return cocoa_st_init_table(&type_pointerhash);
}

cocoa_st_table*
cocoa_st_init_pointertable_with_size(cocoa_st_index_t size)
{
    return cocoa_st_init_table_with_size(&type_pointerhash, size);
}


void
cocoa_st_clear(cocoa_st_table *table)
{
    register cocoa_st_table_entry *ptr, *next;
    cocoa_st_index_t i;

    for(i = 0; i < table->num_bins; i++) {
        ptr = table->bins[i];
        table->bins[i] = 0;
        while (ptr != 0) {
            next = ptr->next;
            free(ptr);
            ptr = next;
        }
    }
    table->num_entries = 0;
    table->head = 0;
    table->tail = 0;
}

void
cocoa_st_free_table(cocoa_st_table *table)
{
    cocoa_st_clear(table);
    free(table->bins);
    free(table);
}

#define PTR_NOT_EQUAL(table, ptr, hash_val, key) \
((ptr) != 0 && (ptr->hash != (hash_val) || !EQUAL((table), (key), (ptr)->key)))

#define FIND_ENTRY(table, ptr, hash_val, bin_pos) do {\
    bin_pos = hash_val%(table)->num_bins;\
    ptr = (table)->bins[bin_pos];\
    if (PTR_NOT_EQUAL(table, ptr, hash_val, key)) {\
        while (PTR_NOT_EQUAL(table, ptr->next, hash_val, key)) {\
            ptr = ptr->next;\
        }\
        ptr = ptr->next;\
    }\
} while (0)

int
cocoa_st_lookup(cocoa_st_table *table, cocoa_st_data_t key, cocoa_st_data_t *value)
{
    unsigned int hash_val, bin_pos;
    register cocoa_st_table_entry *ptr;

    hash_val = do_hash(key, table);
    FIND_ENTRY(table, ptr, hash_val, bin_pos);

    if (ptr == 0) {
        return 0;
    }
    else {
        if (value != 0)  *value = ptr->record;
        return 1;
    }
}

#define ADD_DIRECT(table, key, value, hash_val, bin_pos)\
do {\
    cocoa_st_table_entry *entry;\
    if (table->num_entries/(table->num_bins) > COCOA_ST_DEFAULT_MAX_DENSITY) {\
        rehash(table);\
        bin_pos = hash_val % table->num_bins;\
    }\
    \
    entry = alloc(cocoa_st_table_entry);\
    \
    entry->hash = hash_val;\
    entry->key = key;\
    entry->record = value;\
    entry->next = table->bins[bin_pos];\
    if (table->head != 0) {\
        entry->fore = 0;\
        (entry->back = table->tail)->fore = entry;\
        table->tail = entry;\
    }\
    else {\
        table->head = table->tail = entry;\
        entry->fore = entry->back = 0;\
    }\
    table->bins[bin_pos] = entry;\
    table->num_entries++;\
} while (0)

int
cocoa_st_insert(cocoa_st_table *table, cocoa_st_data_t key, cocoa_st_data_t value)
{
    unsigned int hash_val, bin_pos;
    register cocoa_st_table_entry *ptr;

    hash_val = do_hash(key, table);
    FIND_ENTRY(table, ptr, hash_val, bin_pos);

    if (ptr == 0) {
        ADD_DIRECT(table, key, value, hash_val, bin_pos);
        return 0;
    }
    else {
        ptr->record = value;
        return 1;
    }
}

void
cocoa_st_add_direct(cocoa_st_table *table, cocoa_st_data_t key, cocoa_st_data_t value)
{
    unsigned int hash_val, bin_pos;

    hash_val = do_hash(key, table);
    bin_pos = hash_val % table->num_bins;
    ADD_DIRECT(table, key, value, hash_val, bin_pos);
}

static void
rehash(register cocoa_st_table *table)
{
    register cocoa_st_table_entry *ptr, **new_bins;
    cocoa_st_index_t i, new_num_bins, hash_val;

    new_num_bins = new_size(table->num_bins+1);
    new_bins = (cocoa_st_table_entry**)
        realloc(table->bins, new_num_bins * sizeof(cocoa_st_table_entry*));
    for (i = 0; i < new_num_bins; ++i) new_bins[i] = 0;
    table->num_bins = new_num_bins;
    table->bins = new_bins;

    if ((ptr = table->head) != 0) {
        do {
            hash_val = ptr->hash % new_num_bins;
            ptr->next = new_bins[hash_val];
            new_bins[hash_val] = ptr;
        } while ((ptr = ptr->fore) != 0);
    }
}

cocoa_st_table*
cocoa_st_copy(cocoa_st_table *old_table)
{
    cocoa_st_table *new_table;
    cocoa_st_table_entry *ptr, *entry, *prev, **tail;
    cocoa_st_index_t num_bins = old_table->num_bins;
    cocoa_st_index_t hash_val;

    new_table = alloc(cocoa_st_table);
    if (new_table == 0) {
        return 0;
    }

    *new_table = *old_table;
    new_table->bins = (cocoa_st_table_entry**)
        Calloc((unsigned)num_bins, sizeof(cocoa_st_table_entry*));

    if (new_table->bins == 0) {
        free(new_table);
        return 0;
    }

    if ((ptr = old_table->head) != 0) {
        prev = 0;
        tail = &new_table->head;
        do {
            entry = alloc(cocoa_st_table_entry);
            if (entry == 0) {
                cocoa_st_free_table(new_table);
                return 0;
            }
            *entry = *ptr;
            hash_val = entry->hash % num_bins;
            entry->next = new_table->bins[hash_val];
            new_table->bins[hash_val] = entry;
            entry->back = prev;
            *tail = prev = entry;
            tail = &entry->fore;
        } while ((ptr = ptr->fore) != 0);
        new_table->tail = prev;
    }

    return new_table;
}

#define REMOVE_ENTRY(table, ptr) do                                     \
    {                                                                   \
        if (ptr->fore == 0 && ptr->back == 0) {                         \
            table->head = 0;                                            \
            table->tail = 0;                                            \
        }                                                               \
        else {                                                          \
            cocoa_st_table_entry *fore = ptr->fore, *back = ptr->back;        \
            if (fore) fore->back = back;                                \
            if (back) back->fore = fore;                                \
            if (ptr == table->head) table->head = fore;                 \
            if (ptr == table->tail) table->tail = back;                 \
        }                                                               \
        table->num_entries--;                                           \
    } while (0)

int
cocoa_st_delete(register cocoa_st_table *table, register cocoa_st_data_t *key, cocoa_st_data_t *value)
{
    cocoa_st_index_t hash_val;
    cocoa_st_table_entry **prev;
    register cocoa_st_table_entry *ptr;

    hash_val = do_hash_bin(*key, table);
    for (prev = &table->bins[hash_val]; (ptr = *prev) != 0; prev = &ptr->next) {
        if (EQUAL(table, *key, ptr->key)) {
            *prev = ptr->next;
            REMOVE_ENTRY(table, ptr);
            if (value != 0) *value = ptr->record;
            *key = ptr->key;
            free(ptr);
            return 1;
        }
    }

    if (value != 0) *value = 0;
    return 0;
}

int
cocoa_st_foreach(cocoa_st_table *table, enum cocoa_st_retval (*func)(ANYARGS), cocoa_st_data_t arg)
{
    cocoa_st_table_entry *ptr, **last, *tmp;
    enum cocoa_st_retval retval;
    cocoa_st_index_t i;

    if ((ptr = table->head) != 0) {
        do {
            i = ptr->hash % table->num_bins;
            retval = (*func)(ptr->key, ptr->record, (void*)arg);
            switch (retval) {
              case COCOA_ST_CHECK:    /* check if hash is modified during iteration */
                for (tmp = table->bins[i]; tmp != ptr; tmp = tmp->next) {
                    if (!tmp) {
                        /* call func with error notice */
                        retval = (*func)(0, 0, arg, 1);
                        return 1;
                    }
                }
                /* fall through */
              default:
              case COCOA_ST_CONTINUE:
                ptr = ptr->fore;
                break;
              case COCOA_ST_STOP:
                return 0;
              case COCOA_ST_DELETE:
                last = &table->bins[ptr->hash % table->num_bins];
                for (; (tmp = *last) != 0; last = &tmp->next) {
                    if (ptr == tmp) {
                        tmp = ptr->fore;
                        *last = ptr->next;
                        REMOVE_ENTRY(table, ptr);
                        free(ptr);
                        if (ptr == tmp) return 0;
                        ptr = tmp;
                        break;
                    }
                }
            }
        } while (ptr && table->head);
    }
    return 0;
}

static cocoa_st_index_t
strhash(const char *string)
{
    register int c;

#ifdef HASH_ELFHASH
    register unsigned int h = 0, g;

    while ((c = *string++) != '\0') {
        h = ( h << 4 ) + c;
        if ( g = h & 0xF0000000 )
            h ^= g >> 24;
        h &= ~g;
    }
    return h;
#elif defined(HASH_PERL)
    register int val = 0;

    while ((c = *string++) != '\0') {
        val += c;
        val += (val << 10);
        val ^= (val >> 6);
    }
    val += (val << 3);
    val ^= (val >> 11);

    return val + (val << 15);
#else
    register int val = 0;

    while ((c = *string++) != '\0') {
        val = val*997 + c;
    }

    return val + (val>>5);
#endif
}

#define FNV1_32A_INIT 0x811c9dc5
#define FNV_32_PRIME 0x01000193

int
cocoa_st_strcasecmp(const char *s1, const char *s2)
{
    unsigned int c1, c2;

    while (1) {
        c1 = (unsigned char)*s1++;
        c2 = (unsigned char)*s2++;
        if (c1 == '\0' || c2 == '\0') {
            if (c1 != '\0') return 1;
            if (c2 != '\0') return -1;
            return 0;
        }
        if ((unsigned int)(c1 - 'A') <= ('Z' - 'A')) c1 += 'a' - 'A';
        if ((unsigned int)(c2 - 'A') <= ('Z' - 'A')) c2 += 'a' - 'A';
        if (c1 != c2) {
            if (c1 > c2)
                return 1;
            else
                return -1;
        }
    }
}

int
cocoa_st_strncasecmp(const char *s1, const char *s2, size_t n)
{
    unsigned int c1, c2;

    while (n--) {
        c1 = (unsigned char)*s1++;
        c2 = (unsigned char)*s2++;
        if (c1 == '\0' || c2 == '\0') {
            if (c1 != '\0') return 1;
            if (c2 != '\0') return -1;
            return 0;
        }
        if ((unsigned int)(c1 - 'A') <= ('Z' - 'A')) c1 += 'a' - 'A';
        if ((unsigned int)(c2 - 'A') <= ('Z' - 'A')) c2 += 'a' - 'A';
        if (c1 != c2) {
            if (c1 > c2)
                return 1;
            else
                return -1;
        }
    }
    return 0;
}

static cocoa_st_index_t
strcasehash(cocoa_st_data_t arg)
{
    register const char *string = (const char*)arg;
    register cocoa_st_index_t hval = FNV1_32A_INIT;

    /*
     * FNV-1a hash each octet in the buffer
     */
    while (*string) {
        unsigned int c = (unsigned char)*string++;
        if ((unsigned int)(c - 'A') <= ('Z' - 'A')) c += 'a' - 'A';
        hval ^= c;

        /* multiply by the 32 bit FNV magic prime mod 2^32 */
        hval *= FNV_32_PRIME;
    }
    return hval;
}

static int
numcmp(long x, long y)
{
    return x != y;
}

static cocoa_st_index_t
numhash(long n)
{
    return n;
}

static int pointercmp(void* x, void* y)
{
    return x != y;
}

static cocoa_st_index_t
pointerhash(cocoa_st_data_t n)
{
    return n;
}


#if 0
static enum cocoa_st_retval
f(cocoa_st_data_t key, cocoa_st_data_t val, cocoa_st_data_t a)
{
  printf("tbl=%p key=%s val=%s\n", (cocoa_st_table*)a, (char*)key, (char*)val);
  //  return COCOA_ST_CONTINUE;
}

void
main(int argc, char **argv)
{
  cocoa_st_table *tbl = cocoa_st_init_strtable();
  int i;

  for (i = 1; i<argc; i+=2) {
    cocoa_st_insert(tbl, (cocoa_st_data_t)argv[i], (cocoa_st_data_t)argv[i+1]);
  }
  cocoa_st_foreach(tbl, f, (cocoa_st_data_t)tbl);
  cocoa_st_delete(tbl, (cocoa_st_data_t*)&argv[1], 0);
  cocoa_st_foreach(tbl, f, (cocoa_st_data_t)tbl);
}
#endif

