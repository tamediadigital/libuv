/* Copyright Joyent, Inc. and other Node contributors. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
module deimos.uv.errno;

import core.stdc.errno;

enum UV__EOF     = -4095;
enum UV__UNKNOWN = -4094;

enum UV__EAI_ADDRFAMILY  = -3000;
enum UV__EAI_AGAIN       = -3001;
enum UV__EAI_BADFLAGS    = -3002;
enum UV__EAI_CANCELED    = -3003;
enum UV__EAI_FAIL        = -3004;
enum UV__EAI_FAMILY      = -3005;
enum UV__EAI_MEMORY      = -3006;
enum UV__EAI_NODATA      = -3007;
enum UV__EAI_NONAME      = -3008;
enum UV__EAI_OVERFLOW    = -3009;
enum UV__EAI_SERVICE     = -3010;
enum UV__EAI_SOCKTYPE    = -3011;
enum UV__EAI_BADHINTS    = -3013;
enum UV__EAI_PROTOCOL    = -3014;

/* Only map to the system errno on non-Windows platforms. It's apparently
 * a fairly common practice for Windows programmers to redefine errno codes.
 */
version(Windows) // Win32 ???
{
	private enum _WIN32 = true;
}
else
{
	private enum _WIN32 = false;
}


static if(__traits(compiles, E2BIG) && !_WIN32)
	enum UV__E2BIG = -E2BIG;
else
	enum UV__E2BIG = -4093;


static if(__traits(compiles, EACCES) && !_WIN32)
	enum UV__EACCES = -EACCES;
else
	enum UV__EACCES = -4092;


static if(__traits(compiles, EADDRINUSE) && !_WIN32)
	enum UV__EADDRINUSE = -EADDRINUSE;
else
	enum UV__EADDRINUSE = -4091;


static if(__traits(compiles, EADDRNOTAVAIL) && !_WIN32)
	enum UV__EADDRNOTAVAIL = -EADDRNOTAVAIL;
else
	enum UV__EADDRNOTAVAIL = -4090;


static if(__traits(compiles, EAFNOSUPPORT) && !_WIN32)
	enum UV__EAFNOSUPPORT = -EAFNOSUPPORT;
else
	enum UV__EAFNOSUPPORT = -4089;


static if(__traits(compiles, EAGAIN) && !_WIN32)
	enum UV__EAGAIN = -EAGAIN;
else
	enum UV__EAGAIN = -4088;


static if(__traits(compiles, EALREADY) && !_WIN32)
	enum UV__EALREADY = -EALREADY;
else
	enum UV__EALREADY = -4084;


static if(__traits(compiles, EBADF) && !_WIN32)
	enum UV__EBADF = -EBADF;
else
	enum UV__EBADF = -4083;


static if(__traits(compiles, EBUSY) && !_WIN32)
	enum UV__EBUSY = -EBUSY;
else
	enum UV__EBUSY = -4082;


static if(__traits(compiles, ECANCELED) && !_WIN32)
	enum UV__ECANCELED = -ECANCELED;
else
	enum UV__ECANCELED = -4081;


static if(__traits(compiles, ECHARSET) && !_WIN32)
	enum UV__ECHARSET = -ECHARSET;
else
	enum UV__ECHARSET = -4080;


static if(__traits(compiles, ECONNABORTED) && !_WIN32)
	enum UV__ECONNABORTED = -ECONNABORTED;
else
	enum UV__ECONNABORTED = -4079;


static if(__traits(compiles, ECONNREFUSED) && !_WIN32)
	enum UV__ECONNREFUSED = -ECONNREFUSED;
else
	enum UV__ECONNREFUSED = -4078;


static if(__traits(compiles, ECONNRESET) && !_WIN32)
	enum UV__ECONNRESET = -ECONNRESET;
else
	enum UV__ECONNRESET = -4077;


static if(__traits(compiles, EDESTADDRREQ) && !_WIN32)
	enum UV__EDESTADDRREQ = -EDESTADDRREQ;
else
	enum UV__EDESTADDRREQ = -4076;


static if(__traits(compiles, EEXIST) && !_WIN32)
	enum UV__EEXIST = -EEXIST;
else
	enum UV__EEXIST = -4075;


static if(__traits(compiles, EFAULT) && !_WIN32)
	enum UV__EFAULT = -EFAULT;
else
	enum UV__EFAULT = -4074;


static if(__traits(compiles, EHOSTUNREACH) && !_WIN32)
	enum UV__EHOSTUNREACH = -EHOSTUNREACH;
else
	enum UV__EHOSTUNREACH = -4073;


static if(__traits(compiles, EINTR) && !_WIN32)
	enum UV__EINTR = -EINTR;
else
	enum UV__EINTR = -4072;


static if(__traits(compiles, EINVAL) && !_WIN32)
	enum UV__EINVAL = -EINVAL;
else
	enum UV__EINVAL = -4071;


static if(__traits(compiles, EIO) && !_WIN32)
	enum UV__EIO = -EIO;
else
	enum UV__EIO = -4070;


static if(__traits(compiles, EISCONN) && !_WIN32)
	enum UV__EISCONN = -EISCONN;
else
	enum UV__EISCONN = -4069;


static if(__traits(compiles, EISDIR) && !_WIN32)
	enum UV__EISDIR = -EISDIR;
else
	enum UV__EISDIR = -4068;


static if(__traits(compiles, ELOOP) && !_WIN32)
	enum UV__ELOOP = -ELOOP;
else
	enum UV__ELOOP = -4067;


static if(__traits(compiles, EMFILE) && !_WIN32)
	enum UV__EMFILE = -EMFILE;
else
	enum UV__EMFILE = -4066;


static if(__traits(compiles, EMSGSIZE) && !_WIN32)
	enum UV__EMSGSIZE = -EMSGSIZE;
else
	enum UV__EMSGSIZE = -4065;


static if(__traits(compiles, ENAMETOOLONG) && !_WIN32)
	enum UV__ENAMETOOLONG = -ENAMETOOLONG;
else
	enum UV__ENAMETOOLONG = -4064;


static if(__traits(compiles, ENETDOWN) && !_WIN32)
	enum UV__ENETDOWN = -ENETDOWN;
else
	enum UV__ENETDOWN = -4063;


static if(__traits(compiles, ENETUNREACH) && !_WIN32)
	enum UV__ENETUNREACH = -ENETUNREACH;
else
	enum UV__ENETUNREACH = -4062;


static if(__traits(compiles, ENFILE) && !_WIN32)
	enum UV__ENFILE = -ENFILE;
else
	enum UV__ENFILE = -4061;


static if(__traits(compiles, ENOBUFS) && !_WIN32)
	enum UV__ENOBUFS = -ENOBUFS;
else
	enum UV__ENOBUFS = -4060;


static if(__traits(compiles, ENODEV) && !_WIN32)
	enum UV__ENODEV = -ENODEV;
else
	enum UV__ENODEV = -4059;


static if(__traits(compiles, ENOENT) && !_WIN32)
	enum UV__ENOENT = -ENOENT;
else
	enum UV__ENOENT = -4058;


static if(__traits(compiles, ENOMEM) && !_WIN32)
	enum UV__ENOMEM = -ENOMEM;
else
	enum UV__ENOMEM = -4057;


static if(__traits(compiles, ENONET) && !_WIN32)
	enum UV__ENONET = -ENONET;
else
	enum UV__ENONET = -4056;


static if(__traits(compiles, ENOSPC) && !_WIN32)
	enum UV__ENOSPC = -ENOSPC;
else
	enum UV__ENOSPC = -4055;


static if(__traits(compiles, ENOSYS) && !_WIN32)
	enum UV__ENOSYS = -ENOSYS;
else
	enum UV__ENOSYS = -4054;


static if(__traits(compiles, ENOTCONN) && !_WIN32)
	enum UV__ENOTCONN = -ENOTCONN;
else
	enum UV__ENOTCONN = -4053;


static if(__traits(compiles, ENOTDIR) && !_WIN32)
	enum UV__ENOTDIR = -ENOTDIR;
else
	enum UV__ENOTDIR = -4052;


static if(__traits(compiles, ENOTEMPTY) && !_WIN32)
	enum UV__ENOTEMPTY = -ENOTEMPTY;
else
	enum UV__ENOTEMPTY = -4051;


static if(__traits(compiles, ENOTSOCK) && !_WIN32)
	enum UV__ENOTSOCK = -ENOTSOCK;
else
	enum UV__ENOTSOCK = -4050;


static if(__traits(compiles, ENOTSUP) && !_WIN32)
	enum UV__ENOTSUP = -ENOTSUP;
else
	enum UV__ENOTSUP = -4049;


static if(__traits(compiles, EPERM) && !_WIN32)
	enum UV__EPERM = -EPERM;
else
	enum UV__EPERM = -4048;


static if(__traits(compiles, EPIPE) && !_WIN32)
	enum UV__EPIPE = -EPIPE;
else
	enum UV__EPIPE = -4047;


static if(__traits(compiles, EPROTO) && !_WIN32)
	enum UV__EPROTO = -EPROTO;
else
	enum UV__EPROTO = -4046;


static if(__traits(compiles, EPROTONOSUPPORT) && !_WIN32)
	enum UV__EPROTONOSUPPORT = -EPROTONOSUPPORT;
else
	enum UV__EPROTONOSUPPORT = -4045;


static if(__traits(compiles, EPROTOTYPE) && !_WIN32)
	enum UV__EPROTOTYPE = -EPROTOTYPE;
else
	enum UV__EPROTOTYPE = -4044;


static if(__traits(compiles, EROFS) && !_WIN32)
	enum UV__EROFS = -EROFS;
else
	enum UV__EROFS = -4043;


static if(__traits(compiles, ESHUTDOWN) && !_WIN32)
	enum UV__ESHUTDOWN = -ESHUTDOWN;
else
	enum UV__ESHUTDOWN = -4042;


static if(__traits(compiles, ESPIPE) && !_WIN32)
	enum UV__ESPIPE = -ESPIPE;
else
	enum UV__ESPIPE = -4041;


static if(__traits(compiles, ESRCH) && !_WIN32)
	enum UV__ESRCH = -ESRCH;
else
	enum UV__ESRCH = -4040;


static if(__traits(compiles, ETIMEDOUT) && !_WIN32)
	enum UV__ETIMEDOUT = -ETIMEDOUT;
else
	enum UV__ETIMEDOUT = -4039;


static if(__traits(compiles, ETXTBSY) && !_WIN32)
	enum UV__ETXTBSY = -ETXTBSY;
else
	enum UV__ETXTBSY = -4038;


static if(__traits(compiles, EXDEV) && !_WIN32)
	enum UV__EXDEV = -EXDEV;
else
	enum UV__EXDEV = -4037;


static if(__traits(compiles, EFBIG) && !_WIN32)
	enum UV__EFBIG = -EFBIG;
else
	enum UV__EFBIG = -4036;


static if(__traits(compiles, ENOPROTOOPT) && !_WIN32)
	enum UV__ENOPROTOOPT = -ENOPROTOOPT;
else
	enum UV__ENOPROTOOPT = -4035;


static if(__traits(compiles, ERANGE) && !_WIN32)
	enum UV__ERANGE = -ERANGE;
else
	enum UV__ERANGE = -4034;


static if(__traits(compiles, ENXIO) && !_WIN32)
	enum UV__ENXIO = -ENXIO;
else
	enum UV__ENXIO = -4033;


static if(__traits(compiles, EMLINK) && !_WIN32)
	enum UV__EMLINK = -EMLINK;
else
	enum UV__EMLINK = -4032;


/* EHOSTDOWN is not visible on BSD-like systems when _POSIX_C_SOURCE is
 * defined. Fortunately, its value is always 64 so it's possible albeit
 * icky to hard-code it.
 */
static if(__traits(compiles, EHOSTDOWN) && !_WIN32)
	enum UV__EHOSTDOWN = -EHOSTDOWN;
else
	version(BSD)
		enum UV__EHOSTDOWN = -64;
	else
		enum UV__EHOSTDOWN = -4031;
