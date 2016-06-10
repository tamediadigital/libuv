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

/* See https://github.com/libuv/libuv#documentation for documentation. */
module deimos.uv;
extern(C) @system nothrow @nogc:

public import deimos.uv.errno;
import deimos.uv.version_;
import core.stdc.stddef;
import core.stdc.stdio;
import core.stdc.stdint;
import core.sys.posix.netdb;

version(Windows)
{
	import deimos.uv.win;

	import core.sys.windows.ntdef;
	import core.sys.windows.subauth;

	import core.sys.windows.winsock2;

	import core.sys.windows.mswsock;
	import core.sys.windows.ws2tcpip;
	import core.sys.windows.windows;

	import core.sys.windows.process;
	import core.sys.windows.signal;
	import core.sys.windows.stat;

	import core.stdc.stdint;

	import deimos.uv.utility.tree;
	import deimos.uv.utility.threadpool;
}
else
version(Posix)
{
	import deimos.uv.unix;
	
	alias uv__io_cb = void function(uv_loop_s* loop,
													uv__io_s* w,
													uint events);

	alias uv__async_cb = void function(uv_loop_s* loop,
														 uv__async* w,
														 uint nevents);

	import core.sys.posix.sys.types;
	import core.sys.posix.sys.stat;
	import core.sys.posix.fcntl;
	import core.sys.posix.dirent;

	import core.sys.posix.sys.socket;
	import core.sys.posix.netinet.in_;
	import core.sys.posix.netinet.tcp;
	import core.sys.posix.arpa.inet;
	import core.sys.posix.netdb;

	import core.sys.posix.termios;
	import core.sys.posix.pwd;

	import core.sys.posix.semaphore;
	import core.sys.posix.pthread;
	import core.sys.posix.signal;

	import core.sys.posix.sys.types;
}
else static assert(0, "libuv not implemented for this target.");


struct uv__work {
	void function(uv__work *w) work;
	void function(uv__work *w, int status) done;
	uv_loop_s* loop;
	void*[2] wq;
}

enum uv_errno_t {
	UV_E2BIG = UV__E2BIG,
	UV_EACCES = UV__EACCES,
	UV_EADDRINUSE = UV__EADDRINUSE,
	UV_EADDRNOTAVAIL = UV__EADDRNOTAVAIL,
	UV_EAFNOSUPPORT = UV__EAFNOSUPPORT,
	UV_EAGAIN = UV__EAGAIN,
	UV_EAI_ADDRFAMILY = UV__EAI_ADDRFAMILY,
	UV_EAI_AGAIN = UV__EAI_AGAIN,
	UV_EAI_BADFLAGS = UV__EAI_BADFLAGS,
	UV_EAI_BADHINTS = UV__EAI_BADHINTS,
	UV_EAI_CANCELED = UV__EAI_CANCELED,
	UV_EAI_FAIL = UV__EAI_FAIL,
	UV_EAI_FAMILY = UV__EAI_FAMILY,
	UV_EAI_MEMORY = UV__EAI_MEMORY,
	UV_EAI_NODATA = UV__EAI_NODATA,
	UV_EAI_NONAME = UV__EAI_NONAME,
	UV_EAI_OVERFLOW = UV__EAI_OVERFLOW,
	UV_EAI_PROTOCOL = UV__EAI_PROTOCOL,
	UV_EAI_SERVICE = UV__EAI_SERVICE,
	UV_EAI_SOCKTYPE = UV__EAI_SOCKTYPE,
	UV_EALREADY = UV__EALREADY,
	UV_EBADF = UV__EBADF,
	UV_EBUSY = UV__EBUSY,
	UV_ECANCELED = UV__ECANCELED,
	UV_ECHARSET = UV__ECHARSET,
	UV_ECONNABORTED = UV__ECONNABORTED,
	UV_ECONNREFUSED = UV__ECONNREFUSED,
	UV_ECONNRESET = UV__ECONNRESET,
	UV_EDESTADDRREQ = UV__EDESTADDRREQ,
	UV_EEXIST = UV__EEXIST,
	UV_EFAULT = UV__EFAULT,
	UV_EFBIG = UV__EFBIG,
	UV_EHOSTUNREACH = UV__EHOSTUNREACH,
	UV_EINTR = UV__EINTR,
	UV_EINVAL = UV__EINVAL,
	UV_EIO = UV__EIO,
	UV_EISCONN = UV__EISCONN,
	UV_EISDIR = UV__EISDIR,
	UV_ELOOP = UV__ELOOP,
	UV_EMFILE = UV__EMFILE,
	UV_EMSGSIZE = UV__EMSGSIZE,
	UV_ENAMETOOLONG = UV__ENAMETOOLONG,
	UV_ENETDOWN = UV__ENETDOWN,
	UV_ENETUNREACH = UV__ENETUNREACH,
	UV_ENFILE = UV__ENFILE,
	UV_ENOBUFS = UV__ENOBUFS,
	UV_ENODEV = UV__ENODEV,
	UV_ENOENT = UV__ENOENT,
	UV_ENOMEM = UV__ENOMEM,
	UV_ENONET = UV__ENONET,
	UV_ENOPROTOOPT = UV__ENOPROTOOPT,
	UV_ENOSPC = UV__ENOSPC,
	UV_ENOSYS = UV__ENOSYS,
	UV_ENOTCONN = UV__ENOTCONN,
	UV_ENOTDIR = UV__ENOTDIR,
	UV_ENOTEMPTY = UV__ENOTEMPTY,
	UV_ENOTSOCK = UV__ENOTSOCK,
	UV_ENOTSUP = UV__ENOTSUP,
	UV_EPERM = UV__EPERM,
	UV_EPIPE = UV__EPIPE,
	UV_EPROTO = UV__EPROTO,
	UV_EPROTONOSUPPORT = UV__EPROTONOSUPPORT,
	UV_EPROTOTYPE = UV__EPROTOTYPE,
	UV_ERANGE = UV__ERANGE,
	UV_EROFS = UV__EROFS,
	UV_ESHUTDOWN = UV__ESHUTDOWN,
	UV_ESPIPE = UV__ESPIPE,
	UV_ESRCH = UV__ESRCH,
	UV_ETIMEDOUT = UV__ETIMEDOUT,
	UV_ETXTBSY = UV__ETXTBSY,
	UV_EXDEV = UV__EXDEV,
	UV_UNKNOWN = UV__UNKNOWN,
	UV_EOF = UV__EOF,
	UV_ENXIO = UV__ENXIO,
	UV_EMLINK = UV__EMLINK,
	UV_EHOSTDOWN = UV__EHOSTDOWN,

	UV_ERRNO_MAX = UV__EOF - 1
}

enum uv_handle_type {
	UV_UNKNOWN_HANDLE = 0,
	ASYNC,
	CHECK,
	FS_EVENT,
	FS_POLL,
	HANDLE,
	IDLE,
	NAMED_PIPE,
	POLL,
	PREPARE,
	PROCESS,
	STREAM,
	TCP,
	TIMER,
	TTY,
	UDP,
	SIGNAL,
	UV_FILE,
	UV_HANDLE_TYPE_MAX
}

version(Windows)
{
	enum uv_req_type {
		UV_UNKNOWN_REQ = 0,

		REQ,
		CONNECT,
		WRITE,
		SHUTDOWN,
		UDP_SEND,
		FS,
		WORK,
		GETADDRINFO,
		GETNAMEINFO,

		UV_ACCEPT,
		UV_FS_EVENT_REQ,
		UV_POLL_REQ,
		UV_PROCESS_EXIT,
		UV_READ,
		UV_UDP_RECV,
		UV_WAKEUP,
		UV_SIGNAL_REQ,

		UV_REQ_TYPE_MAX
	}
}
else
{
	enum uv_req_type {
		UV_UNKNOWN_REQ = 0,

		REQ,
		CONNECT,
		WRITE,
		SHUTDOWN,
		UDP_SEND,
		FS,
		WORK,
		GETADDRINFO,
		GETNAMEINFO,

		UV_REQ_TYPE_MAX
	}
}


/* Handle types. */
alias uv_loop_s uv_loop_t;
alias uv_handle_s uv_handle_t;
alias uv_stream_s uv_stream_t;
alias uv_tcp_s uv_tcp_t;
alias uv_udp_s uv_udp_t;
alias uv_pipe_s uv_pipe_t;
alias uv_tty_s uv_tty_t;
alias uv_poll_s uv_poll_t;
alias uv_timer_s uv_timer_t;
alias uv_prepare_s uv_prepare_t;
alias uv_check_s uv_check_t;
alias uv_idle_s uv_idle_t;
alias uv_async_s uv_async_t;
alias uv_process_s uv_process_t;
alias uv_fs_event_s uv_fs_event_t;
alias uv_fs_poll_s uv_fs_poll_t;
alias uv_signal_s uv_signal_t;

/* Request types. */
alias uv_req_s uv_req_t;
alias uv_getaddrinfo_s uv_getaddrinfo_t;
alias uv_getnameinfo_s uv_getnameinfo_t;
alias uv_shutdown_s uv_shutdown_t;
alias uv_write_s uv_write_t;
alias uv_connect_s uv_connect_t;
alias uv_udp_send_s uv_udp_send_t;
alias uv_fs_s uv_fs_t;
alias uv_work_s uv_work_t;

/* None of the above. */
alias uv_cpu_info_s uv_cpu_info_t;
alias uv_interface_address_s uv_interface_address_t;
alias uv_dirent_s uv_dirent_t;
alias uv_passwd_s uv_passwd_t;

enum uv_loop_option {
	UV_LOOP_BLOCK_SIGNAL
}

enum uv_run_mode {
	UV_RUN_DEFAULT = 0,
	UV_RUN_ONCE,
	UV_RUN_NOWAIT
}


extern uint uv_version();
extern const(char)* uv_version_string();

alias uv_malloc_func = void* function(size_t size);
alias uv_realloc_func = void* function(void* ptr, size_t size);
alias uv_calloc_func = void* function(size_t count, size_t size);
alias uv_free_func = void function(void* ptr);

extern int uv_replace_allocator(uv_malloc_func malloc_func,
																	 uv_realloc_func realloc_func,
																	 uv_calloc_func calloc_func,
																	 uv_free_func free_func);

extern uv_loop_t* uv_default_loop();
extern int uv_loop_init(uv_loop_t* loop);
extern int uv_loop_close(uv_loop_t* loop);
/*
 * NOTE:
 *  This function is DEPRECATED (to be removed after 0.12), users should
 *  allocate the loop manually and use uv_loop_init instead.
 */
extern uv_loop_t* uv_loop_new();
/*
 * NOTE:
 *  This function is DEPRECATED (to be removed after 0.12). Users should use
 *  uv_loop_close and free the memory manually instead.
 */
extern void uv_loop_delete(uv_loop_t*);
extern size_t uv_loop_size();
extern int uv_loop_alive(const uv_loop_t* loop);
extern int uv_loop_configure(uv_loop_t* loop, uv_loop_option option, ...);

extern int uv_run(uv_loop_t*, uv_run_mode mode);
extern void uv_stop(uv_loop_t*);

extern void uv_ref(uv_handle_t*);
extern void uv_unref(uv_handle_t*);
extern int uv_has_ref(const uv_handle_t*);

extern void uv_update_time(uv_loop_t*);
extern uint64_t uv_now(const uv_loop_t*);

extern int uv_backend_fd(const uv_loop_t*);
extern int uv_backend_timeout(const uv_loop_t*);

alias uv_alloc_cb = void function(uv_handle_t* handle,
														size_t suggested_size,
														uv_buf_t* buf);
alias uv_read_cb = void function(uv_stream_t* stream,
													 sizediff_t nread,
													 const uv_buf_t* buf);
alias uv_write_cb = void function(uv_write_t* req, int status);
alias uv_connect_cb = void function(uv_connect_t* req, int status);
alias uv_shutdown_cb = void function(uv_shutdown_t* req, int status);
alias uv_connection_cb = void function(uv_stream_t* server, int status);
alias uv_close_cb = void function(uv_handle_t* handle);
alias uv_poll_cb = void function(uv_poll_t* handle, int status, int events);
alias uv_timer_cb = void function(uv_timer_t* handle);
alias uv_async_cb = void function(uv_async_t* handle);
alias uv_prepare_cb = void function(uv_prepare_t* handle);
alias uv_check_cb = void function(uv_check_t* handle);
alias uv_idle_cb = void function(uv_idle_t* handle);
alias uv_exit_cb = void function(uv_process_t*, int64_t exit_status, int term_signal);
alias uv_walk_cb = void function(uv_handle_t* handle, void* arg);
alias uv_fs_cb = void function(uv_fs_t* req);
alias uv_work_cb = void function(uv_work_t* req);
alias uv_after_work_cb = void function(uv_work_t* req, int status);
alias uv_getaddrinfo_cb = void function(uv_getaddrinfo_t* req,
																	int status,
																	addrinfo* res);
alias uv_getnameinfo_cb = void function(uv_getnameinfo_t* req,
																	int status,
																	const(char)* hostname,
																	const(char)* service);

struct uv_timespec_t {
	long tv_sec;
	long tv_nsec;
}


struct uv_stat_t {
	uint64_t st_dev;
	uint64_t st_mode;
	uint64_t st_nlink;
	uint64_t st_uid;
	uint64_t st_gid;
	uint64_t st_rdev;
	uint64_t st_ino;
	uint64_t st_size;
	uint64_t st_blksize;
	uint64_t st_blocks;
	uint64_t st_flags;
	uint64_t st_gen;
	uv_timespec_t st_atim;
	uv_timespec_t st_mtim;
	uv_timespec_t st_ctim;
	uv_timespec_t st_birthtim;
}


alias uv_fs_event_cb = void function(uv_fs_event_t* handle,
															 const(char)* filename,
															 int events,
															 int status);

alias uv_fs_poll_cb = void function(uv_fs_poll_t* handle,
															int status,
															const uv_stat_t* prev,
															const uv_stat_t* curr);

alias uv_signal_cb = void function(uv_signal_t* handle, int signum);


enum uv_membership {
	UV_LEAVE_GROUP = 0,
	UV_JOIN_GROUP
}


extern const(char)* uv_strerror(int err);
extern const(char)* uv_err_name(int err);


mixin template UV_REQ_FIELDS()
{
	/* public */
	void* data;
	/* read-only */
	uv_req_type type;
	/* private */
	void*[2] active_queue;
	void*[4] reserved;
	mixin UV_REQ_PRIVATE_FIELDS;
}

/* Abstract base class of all requests. */
struct uv_req_s {
	mixin UV_REQ_FIELDS;
}


/* Platform-specific request types. */
mixin UV_PRIVATE_REQ_TYPES;


extern int uv_shutdown(uv_shutdown_t* req,
													uv_stream_t* handle,
													uv_shutdown_cb cb);

struct uv_shutdown_s {
	mixin UV_REQ_FIELDS;
	uv_stream_t* handle;
	uv_shutdown_cb cb;
	mixin UV_SHUTDOWN_PRIVATE_FIELDS;
}


mixin template UV_HANDLE_FIELDS()
{
	/* public */
	void* data;
	/* read-only */
	uv_loop_t* loop;
	uv_handle_type type;
	/* private */
	uv_close_cb close_cb;
	void*[2] handle_queue;
	static union U {
		int fd;
		void*[4] reserved;
	}
	U u;
	mixin UV_HANDLE_PRIVATE_FIELDS;
}

/* The abstract base class of all handles. */
struct uv_handle_s {
	mixin UV_HANDLE_FIELDS;
}

extern size_t uv_handle_size(uv_handle_type type);
extern size_t uv_req_size(uv_req_type type);

extern int uv_is_active(const uv_handle_t* handle);

extern void uv_walk(uv_loop_t* loop, uv_walk_cb walk_cb, void* arg);

/* Helpers for ad hoc debugging, no API/ABI stability guaranteed. */
extern void uv_print_all_handles(uv_loop_t* loop, FILE* stream);
extern void uv_print_active_handles(uv_loop_t* loop, FILE* stream);

extern void uv_close(uv_handle_t* handle, uv_close_cb close_cb);

extern int uv_send_buffer_size(uv_handle_t* handle, int* value);
extern int uv_recv_buffer_size(uv_handle_t* handle, int* value);

extern int uv_fileno(const uv_handle_t* handle, uv_os_fd_t* fd);

extern uv_buf_t uv_buf_init(char* base, uint len);


mixin template UV_STREAM_FIELDS()
{
	/* number of bytes queued for writing */
	size_t write_queue_size;
	uv_alloc_cb alloc_cb;
	uv_read_cb read_cb;
	/* private */
	mixin UV_STREAM_PRIVATE_FIELDS;
}

/*
 * uv_stream_t is a subclass of uv_handle_t.
 *
 * uv_stream is an abstract class.
 *
 * uv_stream_t is the parent class of uv_tcp_t, uv_pipe_t and uv_tty_t.
 */
struct uv_stream_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_STREAM_FIELDS;
}

extern int uv_listen(uv_stream_t* stream, int backlog, uv_connection_cb cb);
extern int uv_accept(uv_stream_t* server, uv_stream_t* client);

extern int uv_read_start(uv_stream_t*,
														uv_alloc_cb alloc_cb,
														uv_read_cb read_cb);
extern int uv_read_stop(uv_stream_t*);

extern int uv_write(uv_write_t* req,
											 uv_stream_t* handle,
											 const uv_buf_t[] bufs,
											 uint nbufs,
											 uv_write_cb cb);
extern int uv_write2(uv_write_t* req,
												uv_stream_t* handle,
												const uv_buf_t[] bufs,
												uint nbufs,
												uv_stream_t* send_handle,
												uv_write_cb cb);
extern int uv_try_write(uv_stream_t* handle,
													 const uv_buf_t[] bufs,
													 uint nbufs);

/* uv_write_t is a subclass of uv_req_t. */
struct uv_write_s {
	mixin UV_REQ_FIELDS;
	uv_write_cb cb;
	uv_stream_t* send_handle;
	uv_stream_t* handle;
	mixin UV_WRITE_PRIVATE_FIELDS;
}


extern int uv_is_readable(const uv_stream_t* handle);
extern int uv_is_writable(const uv_stream_t* handle);

extern int uv_stream_set_blocking(uv_stream_t* handle, int blocking);

extern int uv_is_closing(const uv_handle_t* handle);


/*
 * uv_tcp_t is a subclass of uv_stream_t.
 *
 * Represents a TCP stream or TCP server.
 */
struct uv_tcp_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_STREAM_FIELDS;
	mixin UV_TCP_PRIVATE_FIELDS;
}

extern int uv_tcp_init(uv_loop_t*, uv_tcp_t* handle);
extern int uv_tcp_init_ex(uv_loop_t*, uv_tcp_t* handle, uint flags);
extern int uv_tcp_open(uv_tcp_t* handle, uv_os_sock_t sock);
extern int uv_tcp_nodelay(uv_tcp_t* handle, int enable);
extern int uv_tcp_keepalive(uv_tcp_t* handle,
															 int enable,
															 uint delay);
extern int uv_tcp_simultaneous_accepts(uv_tcp_t* handle, int enable);

enum uv_tcp_flags {
	/* Used with uv_tcp_bind, when an IPv6 address is used. */
	UV_TCP_IPV6ONLY = 1
}

extern int uv_tcp_bind(uv_tcp_t* handle,
													const sockaddr* addr,
													uint flags);
extern int uv_tcp_getsockname(const uv_tcp_t* handle,
																 sockaddr* name,
																 int* namelen);
extern int uv_tcp_getpeername(const uv_tcp_t* handle,
																 sockaddr* name,
																 int* namelen);
extern int uv_tcp_connect(uv_connect_t* req,
														 uv_tcp_t* handle,
														 const sockaddr* addr,
														 uv_connect_cb cb);

/* uv_connect_t is a subclass of uv_req_t. */
struct uv_connect_s {
	mixin UV_REQ_FIELDS;
	uv_connect_cb cb;
	uv_stream_t* handle;
	mixin UV_CONNECT_PRIVATE_FIELDS;
}


/*
 * UDP support.
 */

enum uv_udp_flags {
	/* Disables dual stack mode. */
	UV_UDP_IPV6ONLY = 1,
	/*
	 * Indicates message was truncated because read buffer was too small. The
	 * remainder was discarded by the OS. Used in uv_udp_recv_cb.
	 */
	UV_UDP_PARTIAL = 2,
	/*
	 * Indicates if SO_REUSEADDR will be set when binding the handle.
	 * This sets the SO_REUSEPORT socket flag on the BSDs and OS X. On other
	 * Unix platforms, it sets the SO_REUSEADDR flag.  What that means is that
	 * multiple threads or processes can bind to the same address without error
	 * (provided they all set the flag) but only the last one to bind will receive
	 * any traffic, in effect "stealing" the port from the previous listener.
	 */
	UV_UDP_REUSEADDR = 4
}

alias uv_udp_send_cb = void function(uv_udp_send_t* req, int status);
alias uv_udp_recv_cb = void function(uv_udp_t* handle,
															 sizediff_t nread,
															 const uv_buf_t* buf,
															 const sockaddr* addr,
															 uint flags);

/* uv_udp_t is a subclass of uv_handle_t. */
struct uv_udp_s {
	mixin UV_HANDLE_FIELDS;
	/* read-only */
	/*
	 * Number of bytes queued for sending. This field strictly shows how much
	 * information is currently queued.
	 */
	size_t send_queue_size;
	/*
	 * Number of send requests currently in the queue awaiting to be processed.
	 */
	size_t send_queue_count;
	mixin UV_UDP_PRIVATE_FIELDS;
}

/* uv_udp_send_t is a subclass of uv_req_t. */
struct uv_udp_send_s {
	mixin UV_REQ_FIELDS;
	uv_udp_t* handle;
	uv_udp_send_cb cb;
	mixin UV_UDP_SEND_PRIVATE_FIELDS;
}

extern int uv_udp_init(uv_loop_t*, uv_udp_t* handle);
extern int uv_udp_init_ex(uv_loop_t*, uv_udp_t* handle, uint flags);
extern int uv_udp_open(uv_udp_t* handle, uv_os_sock_t sock);
extern int uv_udp_bind(uv_udp_t* handle,
													const sockaddr* addr,
													uint flags);

extern int uv_udp_getsockname(const uv_udp_t* handle,
																 sockaddr* name,
																 int* namelen);
extern int uv_udp_set_membership(uv_udp_t* handle,
																		const(char)* multicast_addr,
																		const(char)* interface_addr,
																		uv_membership membership);
extern int uv_udp_set_multicast_loop(uv_udp_t* handle, int on);
extern int uv_udp_set_multicast_ttl(uv_udp_t* handle, int ttl);
extern int uv_udp_set_multicast_interface(uv_udp_t* handle,
																						 const(char)* interface_addr);
extern int uv_udp_set_broadcast(uv_udp_t* handle, int on);
extern int uv_udp_set_ttl(uv_udp_t* handle, int ttl);
extern int uv_udp_send(uv_udp_send_t* req,
													uv_udp_t* handle,
													const uv_buf_t[] bufs,
													uint nbufs,
													const sockaddr* addr,
													uv_udp_send_cb send_cb);
extern int uv_udp_try_send(uv_udp_t* handle,
															const uv_buf_t[] bufs,
															uint nbufs,
															const sockaddr* addr);
extern int uv_udp_recv_start(uv_udp_t* handle,
																uv_alloc_cb alloc_cb,
																uv_udp_recv_cb recv_cb);
extern int uv_udp_recv_stop(uv_udp_t* handle);


/*
 * uv_tty_t is a subclass of uv_stream_t.
 *
 * Representing a stream for the console.
 */
struct uv_tty_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_STREAM_FIELDS;
	mixin UV_TTY_PRIVATE_FIELDS;
}

enum uv_tty_mode_t {
	/* Initial/normal terminal mode */
	UV_TTY_MODE_NORMAL,
	/* Raw input mode (On Windows, ENABLE_WINDOW_INPUT is also enabled) */
	UV_TTY_MODE_RAW,
	/* Binary-safe I/O mode for IPC (Unix-only) */
	UV_TTY_MODE_IO
}

extern int uv_tty_init(uv_loop_t*, uv_tty_t*, uv_file fd, int readable);
extern int uv_tty_set_mode(uv_tty_t*, uv_tty_mode_t mode);
extern int uv_tty_reset_mode();
extern int uv_tty_get_winsize(uv_tty_t*, int* width, int* height);

extern uv_handle_type uv_guess_handle(uv_file file);

/*
 * uv_pipe_t is a subclass of uv_stream_t.
 *
 * Representing a pipe stream or pipe server. On Windows this is a Named
 * Pipe. On Unix this is a Unix domain socket.
 */
struct uv_pipe_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_STREAM_FIELDS;
	int ipc; /* non-zero if this pipe is used for passing handles */
	mixin UV_PIPE_PRIVATE_FIELDS;
}

extern int uv_pipe_init(uv_loop_t*, uv_pipe_t* handle, int ipc);
extern int uv_pipe_open(uv_pipe_t*, uv_file file);
extern int uv_pipe_bind(uv_pipe_t* handle, const(char)* name);
extern void uv_pipe_connect(uv_connect_t* req,
															 uv_pipe_t* handle,
															 const(char)* name,
															 uv_connect_cb cb);
extern int uv_pipe_getsockname(const uv_pipe_t* handle,
																	char* buffer,
																	size_t* size);
extern int uv_pipe_getpeername(const uv_pipe_t* handle,
																	char* buffer,
																	size_t* size);
extern void uv_pipe_pending_instances(uv_pipe_t* handle, int count);
extern int uv_pipe_pending_count(uv_pipe_t* handle);
extern uv_handle_type uv_pipe_pending_type(uv_pipe_t* handle);


struct uv_poll_s {
	mixin UV_HANDLE_FIELDS;
	uv_poll_cb poll_cb;
	mixin UV_POLL_PRIVATE_FIELDS;
}

enum uv_poll_event {
	UV_READABLE = 1,
	UV_WRITABLE = 2,
	UV_DISCONNECT = 4
}

extern int uv_poll_init(uv_loop_t* loop, uv_poll_t* handle, int fd);
extern int uv_poll_init_socket(uv_loop_t* loop,
																	uv_poll_t* handle,
																	uv_os_sock_t socket);
extern int uv_poll_start(uv_poll_t* handle, int events, uv_poll_cb cb);
extern int uv_poll_stop(uv_poll_t* handle);


struct uv_prepare_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_PREPARE_PRIVATE_FIELDS;
}

extern int uv_prepare_init(uv_loop_t*, uv_prepare_t* prepare);
extern int uv_prepare_start(uv_prepare_t* prepare, uv_prepare_cb cb);
extern int uv_prepare_stop(uv_prepare_t* prepare);


struct uv_check_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_CHECK_PRIVATE_FIELDS;
}

extern int uv_check_init(uv_loop_t*, uv_check_t* check);
extern int uv_check_start(uv_check_t* check, uv_check_cb cb);
extern int uv_check_stop(uv_check_t* check);


struct uv_idle_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_IDLE_PRIVATE_FIELDS;
}

extern int uv_idle_init(uv_loop_t*, uv_idle_t* idle);
extern int uv_idle_start(uv_idle_t* idle, uv_idle_cb cb);
extern int uv_idle_stop(uv_idle_t* idle);


struct uv_async_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_ASYNC_PRIVATE_FIELDS;
}

extern int uv_async_init(uv_loop_t*,
														uv_async_t* async,
														uv_async_cb async_cb);
extern int uv_async_send(uv_async_t* async);


/*
 * uv_timer_t is a subclass of uv_handle_t.
 *
 * Used to get woken up at a specified time in the future.
 */
struct uv_timer_s {
	mixin UV_HANDLE_FIELDS;
	mixin UV_TIMER_PRIVATE_FIELDS;
}

extern int uv_timer_init(uv_loop_t*, uv_timer_t* handle);
extern int uv_timer_start(uv_timer_t* handle,
														 uv_timer_cb cb,
														 uint64_t timeout,
														 uint64_t repeat);
extern int uv_timer_stop(uv_timer_t* handle);
extern int uv_timer_again(uv_timer_t* handle);
extern void uv_timer_set_repeat(uv_timer_t* handle, uint64_t repeat);
extern uint64_t uv_timer_get_repeat(const uv_timer_t* handle);


/*
 * uv_getaddrinfo_t is a subclass of uv_req_t.
 *
 * Request object for uv_getaddrinfo.
 */
struct uv_getaddrinfo_s {
	mixin UV_REQ_FIELDS;
	/* read-only */
	uv_loop_t* loop;
	/* addrinfo* addrinfo is marked as private, but it really isn't. */
	mixin UV_GETADDRINFO_PRIVATE_FIELDS;
}


extern int uv_getaddrinfo(uv_loop_t* loop,
														 uv_getaddrinfo_t* req,
														 uv_getaddrinfo_cb getaddrinfo_cb,
														 const(char)* node,
														 const(char)* service,
														 const addrinfo* hints);
extern void uv_freeaddrinfo(addrinfo* ai);


/*
* uv_getnameinfo_t is a subclass of uv_req_t.
*
* Request object for uv_getnameinfo.
*/
struct uv_getnameinfo_s {
	mixin UV_REQ_FIELDS;
	/* read-only */
	uv_loop_t* loop;
	/* host and service are marked as private, but they really aren't. */
	mixin UV_GETNAMEINFO_PRIVATE_FIELDS;
}

extern int uv_getnameinfo(uv_loop_t* loop,
														 uv_getnameinfo_t* req,
														 uv_getnameinfo_cb getnameinfo_cb,
														 const sockaddr* addr,
														 int flags);


/* uv_spawn() options. */
enum uv_stdio_flags {
	UV_IGNORE         = 0x00,
	UV_CREATE_PIPE    = 0x01,
	UV_INHERIT_FD     = 0x02,
	UV_INHERIT_STREAM = 0x04,

	/*
	 * When UV_CREATE_PIPE is specified, UV_READABLE_PIPE and UV_WRITABLE_PIPE
	 * determine the direction of flow, from the child process' perspective. Both
	 * flags may be specified to create a duplex data stream.
	 */
	UV_READABLE_PIPE  = 0x10,
	UV_WRITABLE_PIPE  = 0x20
}

alias uv_stdio_container_t = uv_stdio_container_s;
struct uv_stdio_container_s {
	uv_stdio_flags flags;

	static union Data {
		uv_stream_t* stream;
		int fd;
	}
	Data data;
}

alias uv_process_options_t = uv_process_options_s;
struct uv_process_options_s {
	uv_exit_cb exit_cb; /* Called after the process exits. */
	const(char)* file;   /* Path to program to execute. */
	/*
	 * Command line arguments. args[0] should be the path to the program. On
	 * Windows this uses CreateProcess which concatenates the arguments into a
	 * string this can cause some strange errors. See the note at
	 * windows_verbatim_arguments.
	 */
	char** args;
	/*
	 * This will be set as the environ variable in the subprocess. If this is
	 * NULL then the parents environ will be used.
	 */
	char** env;
	/*
	 * If non-null this represents a directory the subprocess should execute
	 * in. Stands for current working directory.
	 */
	const(char)* cwd;
	/*
	 * Various flags that control how uv_spawn() behaves. See the definition of
	 * `enum uv_process_flags` below.
	 */
	uint flags;
	/*
	 * The `stdio` field points to an array of uv_stdio_container_t structs that
	 * describe the file descriptors that will be made available to the child
	 * process. The convention is that stdio[0] points to stdin, fd 1 is used for
	 * stdout, and fd 2 is stderr.
	 *
	 * Note that on windows file descriptors greater than 2 are available to the
	 * child process only if the child processes uses the MSVCRT runtime.
	 */
	int stdio_count;
	uv_stdio_container_t* stdio;
	/*
	 * Libuv can change the child process' user/group id. This happens only when
	 * the appropriate bits are set in the flags fields. This is not supported on
	 * windows; uv_spawn() will fail and set the error to UV_ENOTSUP.
	 */
	uv_uid_t uid;
	uv_gid_t gid;
}

/*
 * These are the flags that can be used for the uv_process_options.flags field.
 */
enum uv_process_flags {
	/*
	 * Set the child process' user id. The user id is supplied in the `uid` field
	 * of the options struct. This does not work on windows; setting this flag
	 * will cause uv_spawn() to fail.
	 */
	UV_PROCESS_SETUID = (1 << 0),
	/*
	 * Set the child process' group id. The user id is supplied in the `gid`
	 * field of the options struct. This does not work on windows; setting this
	 * flag will cause uv_spawn() to fail.
	 */
	UV_PROCESS_SETGID = (1 << 1),
	/*
	 * Do not wrap any arguments in quotes, or perform any other escaping, when
	 * converting the argument list into a command line string. This option is
	 * only meaningful on Windows systems. On Unix it is silently ignored.
	 */
	UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS = (1 << 2),
	/*
	 * Spawn the child process in a detached state - this will make it a process
	 * group leader, and will effectively enable the child to keep running after
	 * the parent exits.  Note that the child process will still keep the
	 * parent's event loop alive unless the parent process calls uv_unref() on
	 * the child's process handle.
	 */
	UV_PROCESS_DETACHED = (1 << 3),
	/*
	 * Hide the subprocess console window that would normally be created. This
	 * option is only meaningful on Windows systems. On Unix it is silently
	 * ignored.
	 */
	UV_PROCESS_WINDOWS_HIDE = (1 << 4)
}

/*
 * uv_process_t is a subclass of uv_handle_t.
 */
struct uv_process_s {
	mixin UV_HANDLE_FIELDS;
	uv_exit_cb exit_cb;
	int pid;
	mixin UV_PROCESS_PRIVATE_FIELDS;
}

extern int uv_spawn(uv_loop_t* loop,
											 uv_process_t* handle,
											 const uv_process_options_t* options);
extern int uv_process_kill(uv_process_t*, int signum);
extern int uv_kill(int pid, int signum);


/*
 * uv_work_t is a subclass of uv_req_t.
 */
struct uv_work_s {
	mixin UV_REQ_FIELDS;
	uv_loop_t* loop;
	uv_work_cb work_cb;
	uv_after_work_cb after_work_cb;
	mixin UV_WORK_PRIVATE_FIELDS;
}

extern int uv_queue_work(uv_loop_t* loop,
														uv_work_t* req,
														uv_work_cb work_cb,
														uv_after_work_cb after_work_cb);

extern int uv_cancel(uv_req_t* req);


struct uv_cpu_info_s {
	char* model;
	int speed;
	static struct uv_cpu_times_s {
		uint64_t user;
		uint64_t nice;
		uint64_t sys;
		uint64_t idle;
		uint64_t irq;
	}
	uv_cpu_times_s cpu_times;
}

struct uv_interface_address_s {
	char* name;
	char[6] phys_addr;
	int is_internal;
	static union Address {
		sockaddr_in address4;
		sockaddr_in6 address6;
	}
	Address address;
	static union Netmask {
		sockaddr_in netmask4;
		sockaddr_in6 netmask6;
	}
	Netmask netmask;
}

struct uv_passwd_s {
	char* username;
	long uid;
	long gid;
	char* shell;
	char* homedir;
}

enum uv_dirent_type_t {
	UV_DIRENT_UNKNOWN,
	UV_DIRENT_FILE,
	UV_DIRENT_DIR,
	UV_DIRENT_LINK,
	UV_DIRENT_FIFO,
	UV_DIRENT_SOCKET,
	UV_DIRENT_CHAR,
	UV_DIRENT_BLOCK
}

struct uv_dirent_s {
	const(char)* name;
	uv_dirent_type_t type;
}

extern char** uv_setup_args(int argc, char** argv);
extern int uv_get_process_title(char* buffer, size_t size);
extern int uv_set_process_title(const(char)* title);
extern int uv_resident_set_memory(size_t* rss);
extern int uv_uptime(double* uptime);

struct uv_timeval_t {
	long tv_sec;
	long tv_usec;
}

struct uv_rusage_t {
	 uv_timeval_t ru_utime; /* user CPU time used */
	 uv_timeval_t ru_stime; /* system CPU time used */
	 uint64_t ru_maxrss;    /* maximum resident set size */
	 uint64_t ru_ixrss;     /* integral shared memory size */
	 uint64_t ru_idrss;     /* integral unshared data size */
	 uint64_t ru_isrss;     /* integral unshared stack size */
	 uint64_t ru_minflt;    /* page reclaims (soft page faults) */
	 uint64_t ru_majflt;    /* page faults (hard page faults) */
	 uint64_t ru_nswap;     /* swaps */
	 uint64_t ru_inblock;   /* block input operations */
	 uint64_t ru_oublock;   /* block output operations */
	 uint64_t ru_msgsnd;    /* IPC messages sent */
	 uint64_t ru_msgrcv;    /* IPC messages received */
	 uint64_t ru_nsignals;  /* signals received */
	 uint64_t ru_nvcsw;     /* voluntary context switches */
	 uint64_t ru_nivcsw;    /* involuntary context switches */
}

extern int uv_getrusage(uv_rusage_t* rusage);

extern int uv_os_homedir(char* buffer, size_t* size);
extern int uv_os_tmpdir(char* buffer, size_t* size);
extern int uv_os_get_passwd(uv_passwd_t* pwd);
extern void uv_os_free_passwd(uv_passwd_t* pwd);

extern int uv_cpu_info(uv_cpu_info_t** cpu_infos, int* count);
extern void uv_free_cpu_info(uv_cpu_info_t* cpu_infos, int count);

extern int uv_interface_addresses(uv_interface_address_t** addresses,
																		 int* count);
extern void uv_free_interface_addresses(uv_interface_address_t* addresses,
																					 int count);


enum uv_fs_type {
	UV_FS_UNKNOWN = -1,
	UV_FS_CUSTOM,
	UV_FS_OPEN,
	UV_FS_CLOSE,
	UV_FS_READ,
	UV_FS_WRITE,
	UV_FS_SENDFILE,
	UV_FS_STAT,
	UV_FS_LSTAT,
	UV_FS_FSTAT,
	UV_FS_FTRUNCATE,
	UV_FS_UTIME,
	UV_FS_FUTIME,
	UV_FS_ACCESS,
	UV_FS_CHMOD,
	UV_FS_FCHMOD,
	UV_FS_FSYNC,
	UV_FS_FDATASYNC,
	UV_FS_UNLINK,
	UV_FS_RMDIR,
	UV_FS_MKDIR,
	UV_FS_MKDTEMP,
	UV_FS_RENAME,
	UV_FS_SCANDIR,
	UV_FS_LINK,
	UV_FS_SYMLINK,
	UV_FS_READLINK,
	UV_FS_CHOWN,
	UV_FS_FCHOWN,
	UV_FS_REALPATH
}

/* uv_fs_t is a subclass of uv_req_t. */
struct uv_fs_s {
	mixin UV_REQ_FIELDS;
	uv_fs_type fs_type;
	uv_loop_t* loop;
	uv_fs_cb cb;
	sizediff_t result;
	void* ptr;
	const(char)* path;
	uv_stat_t statbuf;  /* Stores the result of uv_fs_stat() and uv_fs_fstat(). */
	mixin UV_FS_PRIVATE_FIELDS;
}

extern void uv_fs_req_cleanup(uv_fs_t* req);
extern int uv_fs_close(uv_loop_t* loop,
													uv_fs_t* req,
													uv_file file,
													uv_fs_cb cb);
extern int uv_fs_open(uv_loop_t* loop,
												 uv_fs_t* req,
												 const(char)* path,
												 int flags,
												 int mode,
												 uv_fs_cb cb);
extern int uv_fs_read(uv_loop_t* loop,
												 uv_fs_t* req,
												 uv_file file,
												 const uv_buf_t[] bufs,
												 uint nbufs,
												 int64_t offset,
												 uv_fs_cb cb);
extern int uv_fs_unlink(uv_loop_t* loop,
													 uv_fs_t* req,
													 const(char)* path,
													 uv_fs_cb cb);
extern int uv_fs_write(uv_loop_t* loop,
													uv_fs_t* req,
													uv_file file,
													const uv_buf_t[] bufs,
													uint nbufs,
													int64_t offset,
													uv_fs_cb cb);
extern int uv_fs_mkdir(uv_loop_t* loop,
													uv_fs_t* req,
													const(char)* path,
													int mode,
													uv_fs_cb cb);
extern int uv_fs_mkdtemp(uv_loop_t* loop,
														uv_fs_t* req,
														const(char)* tpl,
														uv_fs_cb cb);
extern int uv_fs_rmdir(uv_loop_t* loop,
													uv_fs_t* req,
													const(char)* path,
													uv_fs_cb cb);
extern int uv_fs_scandir(uv_loop_t* loop,
														uv_fs_t* req,
														const(char)* path,
														int flags,
														uv_fs_cb cb);
extern int uv_fs_scandir_next(uv_fs_t* req,
																 uv_dirent_t* ent);
extern int uv_fs_stat(uv_loop_t* loop,
												 uv_fs_t* req,
												 const(char)* path,
												 uv_fs_cb cb);
extern int uv_fs_fstat(uv_loop_t* loop,
													uv_fs_t* req,
													uv_file file,
													uv_fs_cb cb);
extern int uv_fs_rename(uv_loop_t* loop,
													 uv_fs_t* req,
													 const(char)* path,
													 const(char)* new_path,
													 uv_fs_cb cb);
extern int uv_fs_fsync(uv_loop_t* loop,
													uv_fs_t* req,
													uv_file file,
													uv_fs_cb cb);
extern int uv_fs_fdatasync(uv_loop_t* loop,
															uv_fs_t* req,
															uv_file file,
															uv_fs_cb cb);
extern int uv_fs_ftruncate(uv_loop_t* loop,
															uv_fs_t* req,
															uv_file file,
															int64_t offset,
															uv_fs_cb cb);
extern int uv_fs_sendfile(uv_loop_t* loop,
														 uv_fs_t* req,
														 uv_file out_fd,
														 uv_file in_fd,
														 int64_t in_offset,
														 size_t length,
														 uv_fs_cb cb);
extern int uv_fs_access(uv_loop_t* loop,
													 uv_fs_t* req,
													 const(char)* path,
													 int mode,
													 uv_fs_cb cb);
extern int uv_fs_chmod(uv_loop_t* loop,
													uv_fs_t* req,
													const(char)* path,
													int mode,
													uv_fs_cb cb);
extern int uv_fs_utime(uv_loop_t* loop,
													uv_fs_t* req,
													const(char)* path,
													double atime,
													double mtime,
													uv_fs_cb cb);
extern int uv_fs_futime(uv_loop_t* loop,
													 uv_fs_t* req,
													 uv_file file,
													 double atime,
													 double mtime,
													 uv_fs_cb cb);
extern int uv_fs_lstat(uv_loop_t* loop,
													uv_fs_t* req,
													const(char)* path,
													uv_fs_cb cb);
extern int uv_fs_link(uv_loop_t* loop,
												 uv_fs_t* req,
												 const(char)* path,
												 const(char)* new_path,
												 uv_fs_cb cb);

/*
 * This flag can be used with uv_fs_symlink() on Windows to specify whether
 * path argument points to a directory.
 */
enum UV_FS_SYMLINK_DIR          = 0x0001;

/*
 * This flag can be used with uv_fs_symlink() on Windows to specify whether
 * the symlink is to be created using junction points.
 */
enum UV_FS_SYMLINK_JUNCTION     = 0x0002;

extern int uv_fs_symlink(uv_loop_t* loop,
														uv_fs_t* req,
														const(char)* path,
														const(char)* new_path,
														int flags,
														uv_fs_cb cb);
extern int uv_fs_readlink(uv_loop_t* loop,
														 uv_fs_t* req,
														 const(char)* path,
														 uv_fs_cb cb);
extern int uv_fs_realpath(uv_loop_t* loop,
														 uv_fs_t* req,
														 const(char)* path,
														 uv_fs_cb cb);
extern int uv_fs_fchmod(uv_loop_t* loop,
													 uv_fs_t* req,
													 uv_file file,
													 int mode,
													 uv_fs_cb cb);
extern int uv_fs_chown(uv_loop_t* loop,
													uv_fs_t* req,
													const(char)* path,
													uv_uid_t uid,
													uv_gid_t gid,
													uv_fs_cb cb);
extern int uv_fs_fchown(uv_loop_t* loop,
													 uv_fs_t* req,
													 uv_file file,
													 uv_uid_t uid,
													 uv_gid_t gid,
													 uv_fs_cb cb);


enum uv_fs_event {
	UV_RENAME = 1,
	UV_CHANGE = 2
}


struct uv_fs_event_s {
	mixin UV_HANDLE_FIELDS;
	/* private */
	char* path;
	mixin UV_FS_EVENT_PRIVATE_FIELDS;
}


/*
 * uv_fs_stat() based polling file watcher.
 */
struct uv_fs_poll_s {
	mixin UV_HANDLE_FIELDS;
	/* Private, don't touch. */
	void* poll_ctx;
}

extern int uv_fs_poll_init(uv_loop_t* loop, uv_fs_poll_t* handle);
extern int uv_fs_poll_start(uv_fs_poll_t* handle,
															 uv_fs_poll_cb poll_cb,
															 const(char)* path,
															 uint interval);
extern int uv_fs_poll_stop(uv_fs_poll_t* handle);
extern int uv_fs_poll_getpath(uv_fs_poll_t* handle,
																 char* buffer,
																 size_t* size);


struct uv_signal_s {
	mixin UV_HANDLE_FIELDS;
	uv_signal_cb signal_cb;
	int signum;
	mixin UV_SIGNAL_PRIVATE_FIELDS;
}

extern int uv_signal_init(uv_loop_t* loop, uv_signal_t* handle);
extern int uv_signal_start(uv_signal_t* handle,
															uv_signal_cb signal_cb,
															int signum);
extern int uv_signal_stop(uv_signal_t* handle);

extern void uv_loadavg(double[3] avg);


/*
 * Flags to be passed to uv_fs_event_start().
 */
enum uv_fs_event_flags {
	/*
	 * By default, if the fs event watcher is given a directory name, we will
	 * watch for all events in that directory. This flags overrides this behavior
	 * and makes fs_event report only changes to the directory entry itself. This
	 * flag does not affect individual files watched.
	 * This flag is currently not implemented yet on any backend.
	 */
	UV_FS_EVENT_WATCH_ENTRY = 1,

	/*
	 * By default uv_fs_event will try to use a kernel interface such as inotify
	 * or kqueue to detect events. This may not work on remote filesystems such
	 * as NFS mounts. This flag makes fs_event fall back to calling stat() on a
	 * regular interval.
	 * This flag is currently not implemented yet on any backend.
	 */
	UV_FS_EVENT_STAT = 2,

	/*
	 * By default, event watcher, when watching directory, is not registering
	 * (is ignoring) changes in it's subdirectories.
	 * This flag will override this behaviour on platforms that support it.
	 */
	UV_FS_EVENT_RECURSIVE = 4
}


extern int uv_fs_event_init(uv_loop_t* loop, uv_fs_event_t* handle);
extern int uv_fs_event_start(uv_fs_event_t* handle,
																uv_fs_event_cb cb,
																const(char)* path,
																uint flags);
extern int uv_fs_event_stop(uv_fs_event_t* handle);
extern int uv_fs_event_getpath(uv_fs_event_t* handle,
																	char* buffer,
																	size_t* size);

extern int uv_ip4_addr(const(char)* ip, int port, sockaddr_in* addr);
extern int uv_ip6_addr(const(char)* ip, int port, sockaddr_in6* addr);

extern int uv_ip4_name(const sockaddr_in* src, char* dst, size_t size);
extern int uv_ip6_name(const sockaddr_in6* src, char* dst, size_t size);

extern int uv_inet_ntop(int af, const void* src, char* dst, size_t size);
extern int uv_inet_pton(int af, const(char)* src, void* dst);

extern int uv_exepath(char* buffer, size_t* size);

extern int uv_cwd(char* buffer, size_t* size);

extern int uv_chdir(const(char)* dir);

extern uint64_t uv_get_free_memory();
extern uint64_t uv_get_total_memory();

extern uint64_t uv_hrtime();

extern void uv_disable_stdio_inheritance();

extern int uv_dlopen(const(char)* filename, uv_lib_t* lib);
extern void uv_dlclose(uv_lib_t* lib);
extern int uv_dlsym(uv_lib_t* lib, const(char)* name, void** ptr);
extern const(char)* uv_dlerror(const uv_lib_t* lib);

extern int uv_mutex_init(uv_mutex_t* handle);
extern void uv_mutex_destroy(uv_mutex_t* handle);
extern void uv_mutex_lock(uv_mutex_t* handle);
extern int uv_mutex_trylock(uv_mutex_t* handle);
extern void uv_mutex_unlock(uv_mutex_t* handle);

extern int uv_rwlock_init(uv_rwlock_t* rwlock);
extern void uv_rwlock_destroy(uv_rwlock_t* rwlock);
extern void uv_rwlock_rdlock(uv_rwlock_t* rwlock);
extern int uv_rwlock_tryrdlock(uv_rwlock_t* rwlock);
extern void uv_rwlock_rdunlock(uv_rwlock_t* rwlock);
extern void uv_rwlock_wrlock(uv_rwlock_t* rwlock);
extern int uv_rwlock_trywrlock(uv_rwlock_t* rwlock);
extern void uv_rwlock_wrunlock(uv_rwlock_t* rwlock);

extern int uv_sem_init(uv_sem_t* sem, uint value);
extern void uv_sem_destroy(uv_sem_t* sem);
extern void uv_sem_post(uv_sem_t* sem);
extern void uv_sem_wait(uv_sem_t* sem);
extern int uv_sem_trywait(uv_sem_t* sem);

extern int uv_cond_init(uv_cond_t* cond);
extern void uv_cond_destroy(uv_cond_t* cond);
extern void uv_cond_signal(uv_cond_t* cond);
extern void uv_cond_broadcast(uv_cond_t* cond);

extern int uv_barrier_init(uv_barrier_t* barrier, uint count);
extern void uv_barrier_destroy(uv_barrier_t* barrier);
extern int uv_barrier_wait(uv_barrier_t* barrier);

extern void uv_cond_wait(uv_cond_t* cond, uv_mutex_t* mutex);
extern int uv_cond_timedwait(uv_cond_t* cond,
																uv_mutex_t* mutex,
																uint64_t timeout);

extern void uv_once(uv_once_t* guard, void function() callback);

extern int uv_key_create(uv_key_t* key);
extern void uv_key_delete(uv_key_t* key);
extern void* uv_key_get(uv_key_t* key);
extern void uv_key_set(uv_key_t* key, void* value);

alias uv_thread_cb = void function(void* arg);

extern int uv_thread_create(uv_thread_t* tid, uv_thread_cb entry, void* arg);
extern uv_thread_t uv_thread_self();
extern int uv_thread_join(uv_thread_t *tid);
extern int uv_thread_equal(const uv_thread_t* t1, const uv_thread_t* t2);

union uv_any_handle {
	uv_async_t async;
	uv_check_t check;
	uv_fs_event_t fs_event;
	uv_fs_poll_t fs_poll;
	uv_handle_t handle;
	uv_idle_t idle;
	uv_pipe_t pipe;
	uv_poll_t poll;
	uv_prepare_t prepare;
	uv_process_t process;
	uv_stream_t stream;
	uv_tcp_t tcp;
	uv_timer_t timer;
	uv_tty_t tty;
	uv_udp_t udp;
	uv_signal_t signal;
}

union uv_any_req {
	uv_req_t req;
	uv_connect_t connect;
	uv_write_t write;
	uv_shutdown_t shutdown;
	uv_udp_send_t udp_send;
	uv_fs_t fs;
	uv_work_t work;
	uv_getaddrinfo_t getaddrinfo;
	uv_getnameinfo_t getnameinfo;
}

struct uv_loop_s {
	/* User data - use this for whatever. */
	void* data;
	/* Loop reference counting. */
	uint active_handles;
	void*[2] handle_queue;
	void*[2] active_reqs;
	/* Internal flag to signal loop stop. */
	uint stop_flag;
	mixin UV_LOOP_PRIVATE_FIELDS;
}
