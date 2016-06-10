/*
Copyright (c) 2016, Kari Tristan Helgason <kthelgason@gmail.com>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

module deimos.uv.utility.pthread_barrier;
extern(C) @system nothrow @nogc:

import core.stdc.errno;
import core.sys.posix.pthread;
import core.sys.posix.semaphore; /* sem_t */

enum PTHREAD_BARRIER_SERIAL_THREAD = 0x12345;

/*
 * To maintain ABI compatibility with
 * libuv v1.x struct is padded according
 * to target platform
 */
version(Android)
{
  enum UV_BARRIER_STRUCT_PADDING =
    pthread_mutex_t.sizeof +
    pthread_cond_t.sizeof +
    uint.sizeof -
    (void*).sizeof ;
  version = Android_or_OSX;
}
else
version(OSX)
{
  enum UV_BARRIER_STRUCT_PADDING =
    pthread_mutex_t.sizeof +
    2 * sem_t.sizeof +
    2 * uint.sizeof -
    (void*).sizeof ;
  version = Android_or_OSX;
}

version(Android_or_OSX):

struct _uv_barrier {
  pthread_mutex_t  mutex;
  pthread_cond_t   cond;
  uint         threshold;
  uint         in_;
  uint         out_;
}

struct pthread_barrier_t {
  _uv_barrier* b;
  char[UV_BARRIER_STRUCT_PADDING] _pad;
}

int pthread_barrier_init(pthread_barrier_t* barrier,
                         const void* barrier_attr,
                         uint count);

int pthread_barrier_wait(pthread_barrier_t* barrier);
int pthread_barrier_destroy(pthread_barrier_t *barrier);
