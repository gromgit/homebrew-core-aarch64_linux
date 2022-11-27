class LibfuseAT2 < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://github.com/libfuse/libfuse/releases/download/fuse-2.9.9/fuse-2.9.9.tar.gz"
  sha256 "d0e69d5d608cc22ff4843791ad097f554dd32540ddc9bed7638cc6fea7c1b4b5"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libfuse@2"
    sha256 aarch64_linux: "7d69afb648136e44c6306944eb7c41c52d594d8773f209c470816d6823f8ebd5"
  end

  keg_only :versioned_formula

  depends_on :linux

  # Remove basic type redefinitions and ulockmgr
  # Modified from:
  #   https://github.com/libfuse/libfuse/commit/6b02a7082ae4c560427ff95b51aa8930bb4a6e1f
  #   https://github.com/libfuse/libfuse/commit/3c3f03b81f3027ef0a25bd790605265b384b93c1
  patch :DATA

  def install
    ENV["INIT_D_PATH"] = etc/"init.d"
    ENV["UDEV_RULES_PATH"] = etc/"udev/rules.d"
    ENV["MOUNT_FUSE_PATH"] = bin
    system "./configure", *std_configure_args, "--enable-lib", "--enable-util", "--disable-example"
    system "make"
    system "make", "install"
    (pkgshare/"doc").install "doc/kernel.txt"
  end

  test do
    (testpath/"fuse-test.c").write <<~EOS
      #define FUSE_USE_VERSION 21
      #include <fuse/fuse.h>
      #include <stdio.h>
      int main() {
        printf("%d%d\\n", FUSE_MAJOR_VERSION, FUSE_MINOR_VERSION);
        printf("%d\\n", fuse_version());
        return 0;
      }
    EOS
    system ENV.cc, "fuse-test.c", "-L#{lib}", "-I#{include}", "-D_FILE_OFFSET_BITS=64", "-lfuse", "-o", "fuse-test"
    system "./fuse-test"
  end
end
__END__
diff --git a/include/fuse_kernel.h b/include/fuse_kernel.h
index c632b58..74c5129 100644
--- a/include/fuse_kernel.h
+++ b/include/fuse_kernel.h
@@ -88,12 +88,11 @@
 #ifndef _LINUX_FUSE_H
 #define _LINUX_FUSE_H
 
-#include <sys/types.h>
-#define __u64 uint64_t
-#define __s64 int64_t
-#define __u32 uint32_t
-#define __s32 int32_t
-#define __u16 uint16_t
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
 
 /*
  * Version negotiation:
@@ -128,42 +127,42 @@
    userspace works under 64bit kernels */
 
 struct fuse_attr {
-	__u64	ino;
-	__u64	size;
-	__u64	blocks;
-	__u64	atime;
-	__u64	mtime;
-	__u64	ctime;
-	__u32	atimensec;
-	__u32	mtimensec;
-	__u32	ctimensec;
-	__u32	mode;
-	__u32	nlink;
-	__u32	uid;
-	__u32	gid;
-	__u32	rdev;
-	__u32	blksize;
-	__u32	padding;
+	uint64_t	ino;
+	uint64_t	size;
+	uint64_t	blocks;
+	uint64_t	atime;
+	uint64_t	mtime;
+	uint64_t	ctime;
+	uint32_t	atimensec;
+	uint32_t	mtimensec;
+	uint32_t	ctimensec;
+	uint32_t	mode;
+	uint32_t	nlink;
+	uint32_t	uid;
+	uint32_t	gid;
+	uint32_t	rdev;
+	uint32_t	blksize;
+	uint32_t	padding;
 };
 
 struct fuse_kstatfs {
-	__u64	blocks;
-	__u64	bfree;
-	__u64	bavail;
-	__u64	files;
-	__u64	ffree;
-	__u32	bsize;
-	__u32	namelen;
-	__u32	frsize;
-	__u32	padding;
-	__u32	spare[6];
+	uint64_t	blocks;
+	uint64_t	bfree;
+	uint64_t	bavail;
+	uint64_t	files;
+	uint64_t	ffree;
+	uint32_t	bsize;
+	uint32_t	namelen;
+	uint32_t	frsize;
+	uint32_t	padding;
+	uint32_t	spare[6];
 };
 
 struct fuse_file_lock {
-	__u64	start;
-	__u64	end;
-	__u32	type;
-	__u32	pid; /* tgid */
+	uint64_t	start;
+	uint64_t	end;
+	uint32_t	type;
+	uint32_t	pid; /* tgid */
 };
 
 /**
@@ -334,143 +333,143 @@ enum fuse_notify_code {
 #define FUSE_COMPAT_ENTRY_OUT_SIZE 120
 
 struct fuse_entry_out {
-	__u64	nodeid;		/* Inode ID */
-	__u64	generation;	/* Inode generation: nodeid:gen must
-				   be unique for the fs's lifetime */
-	__u64	entry_valid;	/* Cache timeout for the name */
-	__u64	attr_valid;	/* Cache timeout for the attributes */
-	__u32	entry_valid_nsec;
-	__u32	attr_valid_nsec;
+	uint64_t	nodeid;		/* Inode ID */
+	uint64_t	generation;	/* Inode generation: nodeid:gen must
+					   be unique for the fs's lifetime */
+	uint64_t	entry_valid;	/* Cache timeout for the name */
+	uint64_t	attr_valid;	/* Cache timeout for the attributes */
+	uint32_t	entry_valid_nsec;
+	uint32_t	attr_valid_nsec;
 	struct fuse_attr attr;
 };
 
 struct fuse_forget_in {
-	__u64	nlookup;
+	uint64_t	nlookup;
 };
 
 struct fuse_forget_one {
-	__u64	nodeid;
-	__u64	nlookup;
+	uint64_t	nodeid;
+	uint64_t	nlookup;
 };
 
 struct fuse_batch_forget_in {
-	__u32	count;
-	__u32	dummy;
+	uint32_t	count;
+	uint32_t	dummy;
 };
 
 struct fuse_getattr_in {
-	__u32	getattr_flags;
-	__u32	dummy;
-	__u64	fh;
+	uint32_t	getattr_flags;
+	uint32_t	dummy;
+	uint64_t	fh;
 };
 
 #define FUSE_COMPAT_ATTR_OUT_SIZE 96
 
 struct fuse_attr_out {
-	__u64	attr_valid;	/* Cache timeout for the attributes */
-	__u32	attr_valid_nsec;
-	__u32	dummy;
+	uint64_t	attr_valid;	/* Cache timeout for the attributes */
+	uint32_t	attr_valid_nsec;
+	uint32_t	dummy;
 	struct fuse_attr attr;
 };
 
 #define FUSE_COMPAT_MKNOD_IN_SIZE 8
 
 struct fuse_mknod_in {
-	__u32	mode;
-	__u32	rdev;
-	__u32	umask;
-	__u32	padding;
+	uint32_t	mode;
+	uint32_t	rdev;
+	uint32_t	umask;
+	uint32_t	padding;
 };
 
 struct fuse_mkdir_in {
-	__u32	mode;
-	__u32	umask;
+	uint32_t	mode;
+	uint32_t	umask;
 };
 
 struct fuse_rename_in {
-	__u64	newdir;
+	uint64_t	newdir;
 };
 
 struct fuse_link_in {
-	__u64	oldnodeid;
+	uint64_t	oldnodeid;
 };
 
 struct fuse_setattr_in {
-	__u32	valid;
-	__u32	padding;
-	__u64	fh;
-	__u64	size;
-	__u64	lock_owner;
-	__u64	atime;
-	__u64	mtime;
-	__u64	unused2;
-	__u32	atimensec;
-	__u32	mtimensec;
-	__u32	unused3;
-	__u32	mode;
-	__u32	unused4;
-	__u32	uid;
-	__u32	gid;
-	__u32	unused5;
+	uint32_t	valid;
+	uint32_t	padding;
+	uint64_t	fh;
+	uint64_t	size;
+	uint64_t	lock_owner;
+	uint64_t	atime;
+	uint64_t	mtime;
+	uint64_t	unused2;
+	uint32_t	atimensec;
+	uint32_t	mtimensec;
+	uint32_t	unused3;
+	uint32_t	mode;
+	uint32_t	unused4;
+	uint32_t	uid;
+	uint32_t	gid;
+	uint32_t	unused5;
 };
 
 struct fuse_open_in {
-	__u32	flags;
-	__u32	unused;
+	uint32_t	flags;
+	uint32_t	unused;
 };
 
 struct fuse_create_in {
-	__u32	flags;
-	__u32	mode;
-	__u32	umask;
-	__u32	padding;
+	uint32_t	flags;
+	uint32_t	mode;
+	uint32_t	umask;
+	uint32_t	padding;
 };
 
 struct fuse_open_out {
-	__u64	fh;
-	__u32	open_flags;
-	__u32	padding;
+	uint64_t	fh;
+	uint32_t	open_flags;
+	uint32_t	padding;
 };
 
 struct fuse_release_in {
-	__u64	fh;
-	__u32	flags;
-	__u32	release_flags;
-	__u64	lock_owner;
+	uint64_t	fh;
+	uint32_t	flags;
+	uint32_t	release_flags;
+	uint64_t	lock_owner;
 };
 
 struct fuse_flush_in {
-	__u64	fh;
-	__u32	unused;
-	__u32	padding;
-	__u64	lock_owner;
+	uint64_t	fh;
+	uint32_t	unused;
+	uint32_t	padding;
+	uint64_t	lock_owner;
 };
 
 struct fuse_read_in {
-	__u64	fh;
-	__u64	offset;
-	__u32	size;
-	__u32	read_flags;
-	__u64	lock_owner;
-	__u32	flags;
-	__u32	padding;
+	uint64_t	fh;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	read_flags;
+	uint64_t	lock_owner;
+	uint32_t	flags;
+	uint32_t	padding;
 };
 
 #define FUSE_COMPAT_WRITE_IN_SIZE 24
 
 struct fuse_write_in {
-	__u64	fh;
-	__u64	offset;
-	__u32	size;
-	__u32	write_flags;
-	__u64	lock_owner;
-	__u32	flags;
-	__u32	padding;
+	uint64_t	fh;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	write_flags;
+	uint64_t	lock_owner;
+	uint32_t	flags;
+	uint32_t	padding;
 };
 
 struct fuse_write_out {
-	__u32	size;
-	__u32	padding;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 #define FUSE_COMPAT_STATFS_SIZE 48
@@ -480,32 +479,32 @@ struct fuse_statfs_out {
 };
 
 struct fuse_fsync_in {
-	__u64	fh;
-	__u32	fsync_flags;
-	__u32	padding;
+	uint64_t	fh;
+	uint32_t	fsync_flags;
+	uint32_t	padding;
 };
 
 struct fuse_setxattr_in {
-	__u32	size;
-	__u32	flags;
+	uint32_t	size;
+	uint32_t	flags;
 };
 
 struct fuse_getxattr_in {
-	__u32	size;
-	__u32	padding;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 struct fuse_getxattr_out {
-	__u32	size;
-	__u32	padding;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 struct fuse_lk_in {
-	__u64	fh;
-	__u64	owner;
+	uint64_t	fh;
+	uint64_t	owner;
 	struct fuse_file_lock lk;
-	__u32	lk_flags;
-	__u32	padding;
+	uint32_t	lk_flags;
+	uint32_t	padding;
 };
 
 struct fuse_lk_out {
@@ -513,179 +512,179 @@ struct fuse_lk_out {
 };
 
 struct fuse_access_in {
-	__u32	mask;
-	__u32	padding;
+	uint32_t	mask;
+	uint32_t	padding;
 };
 
 struct fuse_init_in {
-	__u32	major;
-	__u32	minor;
-	__u32	max_readahead;
-	__u32	flags;
+	uint32_t	major;
+	uint32_t	minor;
+	uint32_t	max_readahead;
+	uint32_t	flags;
 };
 
 struct fuse_init_out {
-	__u32	major;
-	__u32	minor;
-	__u32	max_readahead;
-	__u32	flags;
-	__u16   max_background;
-	__u16   congestion_threshold;
-	__u32	max_write;
+	uint32_t	major;
+	uint32_t	minor;
+	uint32_t	max_readahead;
+	uint32_t	flags;
+	uint16_t	max_background;
+	uint16_t	congestion_threshold;
+	uint32_t	max_write;
 };
 
 #define CUSE_INIT_INFO_MAX 4096
 
 struct cuse_init_in {
-	__u32	major;
-	__u32	minor;
-	__u32	unused;
-	__u32	flags;
+	uint32_t	major;
+	uint32_t	minor;
+	uint32_t	unused;
+	uint32_t	flags;
 };
 
 struct cuse_init_out {
-	__u32	major;
-	__u32	minor;
-	__u32	unused;
-	__u32	flags;
-	__u32	max_read;
-	__u32	max_write;
-	__u32	dev_major;		/* chardev major */
-	__u32	dev_minor;		/* chardev minor */
-	__u32	spare[10];
+	uint32_t	major;
+	uint32_t	minor;
+	uint32_t	unused;
+	uint32_t	flags;
+	uint32_t	max_read;
+	uint32_t	max_write;
+	uint32_t	dev_major;		/* chardev major */
+	uint32_t	dev_minor;		/* chardev minor */
+	uint32_t	spare[10];
 };
 
 struct fuse_interrupt_in {
-	__u64	unique;
+	uint64_t	unique;
 };
 
 struct fuse_bmap_in {
-	__u64	block;
-	__u32	blocksize;
-	__u32	padding;
+	uint64_t	block;
+	uint32_t	blocksize;
+	uint32_t	padding;
 };
 
 struct fuse_bmap_out {
-	__u64	block;
+	uint64_t	block;
 };
 
 struct fuse_ioctl_in {
-	__u64	fh;
-	__u32	flags;
-	__u32	cmd;
-	__u64	arg;
-	__u32	in_size;
-	__u32	out_size;
+	uint64_t	fh;
+	uint32_t	flags;
+	uint32_t	cmd;
+	uint64_t	arg;
+	uint32_t	in_size;
+	uint32_t	out_size;
 };
 
 struct fuse_ioctl_iovec {
-	__u64	base;
-	__u64	len;
+	uint64_t	base;
+	uint64_t	len;
 };
 
 struct fuse_ioctl_out {
-	__s32	result;
-	__u32	flags;
-	__u32	in_iovs;
-	__u32	out_iovs;
+	int32_t		result;
+	uint32_t	flags;
+	uint32_t	in_iovs;
+	uint32_t	out_iovs;
 };
 
 struct fuse_poll_in {
-	__u64	fh;
-	__u64	kh;
-	__u32	flags;
-	__u32   padding;
+	uint64_t	fh;
+	uint64_t	kh;
+	uint32_t	flags;
+	uint32_t	padding;
 };
 
 struct fuse_poll_out {
-	__u32	revents;
-	__u32	padding;
+	uint32_t	revents;
+	uint32_t	padding;
 };
 
 struct fuse_notify_poll_wakeup_out {
-	__u64	kh;
+	uint64_t	kh;
 };
 
 struct fuse_fallocate_in {
-	__u64	fh;
-	__u64	offset;
-	__u64	length;
-	__u32	mode;
-	__u32	padding;
+	uint64_t	fh;
+	uint64_t	offset;
+	uint64_t	length;
+	uint32_t	mode;
+	uint32_t	padding;
 };
 
 struct fuse_in_header {
-	__u32	len;
-	__u32	opcode;
-	__u64	unique;
-	__u64	nodeid;
-	__u32	uid;
-	__u32	gid;
-	__u32	pid;
-	__u32	padding;
+	uint32_t	len;
+	uint32_t	opcode;
+	uint64_t	unique;
+	uint64_t	nodeid;
+	uint32_t	uid;
+	uint32_t	gid;
+	uint32_t	pid;
+	uint32_t	padding;
 };
 
 struct fuse_out_header {
-	__u32	len;
-	__s32	error;
-	__u64	unique;
+	uint32_t	len;
+	int32_t		error;
+	uint64_t	unique;
 };
 
 struct fuse_dirent {
-	__u64	ino;
-	__u64	off;
-	__u32	namelen;
-	__u32	type;
+	uint64_t	ino;
+	uint64_t	off;
+	uint32_t	namelen;
+	uint32_t	type;
 	char name[];
 };
 
 #define FUSE_NAME_OFFSET offsetof(struct fuse_dirent, name)
-#define FUSE_DIRENT_ALIGN(x) (((x) + sizeof(__u64) - 1) & ~(sizeof(__u64) - 1))
+#define FUSE_DIRENT_ALIGN(x) (((x) + sizeof(uint64_t) - 1) & ~(sizeof(uint64_t) - 1))
 #define FUSE_DIRENT_SIZE(d) \
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET + (d)->namelen)
 
 struct fuse_notify_inval_inode_out {
-	__u64	ino;
-	__s64	off;
-	__s64	len;
+	uint64_t	ino;
+	int64_t		off;
+	int64_t		len;
 };
 
 struct fuse_notify_inval_entry_out {
-	__u64	parent;
-	__u32	namelen;
-	__u32	padding;
+	uint64_t	parent;
+	uint32_t	namelen;
+	uint32_t	padding;
 };
 
 struct fuse_notify_delete_out {
-	__u64	parent;
-	__u64	child;
-	__u32	namelen;
-	__u32	padding;
+	uint64_t	parent;
+	uint64_t	child;
+	uint32_t	namelen;
+	uint32_t	padding;
 };
 
 struct fuse_notify_store_out {
-	__u64	nodeid;
-	__u64	offset;
-	__u32	size;
-	__u32	padding;
+	uint64_t	nodeid;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 struct fuse_notify_retrieve_out {
-	__u64	notify_unique;
-	__u64	nodeid;
-	__u64	offset;
-	__u32	size;
-	__u32	padding;
+	uint64_t	notify_unique;
+	uint64_t	nodeid;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	padding;
 };
 
 /* Matches the size of fuse_write_in */
 struct fuse_notify_retrieve_in {
-	__u64	dummy1;
-	__u64	offset;
-	__u32	size;
-	__u32	dummy2;
-	__u64	dummy3;
-	__u64	dummy4;
+	uint64_t	dummy1;
+	uint64_t	offset;
+	uint32_t	size;
+	uint32_t	dummy2;
+	uint64_t	dummy3;
+	uint64_t	dummy4;
 };
 
 #endif /* _LINUX_FUSE_H */
diff --git a/util/Makefile.am b/util/Makefile.am
index 059d5fc..f971d0c 100644
--- a/util/Makefile.am
+++ b/util/Makefile.am
@@ -1,7 +1,7 @@
 ## Process this file with automake to produce Makefile.in
 
 AM_CPPFLAGS = -D_FILE_OFFSET_BITS=64 
-bin_PROGRAMS = fusermount ulockmgr_server
+bin_PROGRAMS = fusermount
 noinst_PROGRAMS = mount.fuse
 
 # we re-use mount_util.c from the library, but do want to keep ourself
diff --git a/util/Makefile.in b/util/Makefile.in
index 0dd1007..3558cbb 100644
--- a/util/Makefile.in
+++ b/util/Makefile.in
@@ -89,7 +89,7 @@ POST_UNINSTALL = :
 build_triplet = @build@
 host_triplet = @host@
 target_triplet = @target@
-bin_PROGRAMS = fusermount$(EXEEXT) ulockmgr_server$(EXEEXT)
+bin_PROGRAMS = fusermount$(EXEEXT)
 noinst_PROGRAMS = mount.fuse$(EXEEXT)
 subdir = util
 ACLOCAL_M4 = $(top_srcdir)/aclocal.m4

