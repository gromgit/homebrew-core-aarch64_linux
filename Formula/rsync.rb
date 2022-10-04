class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.5.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.5.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.5.tar.gz"
  sha256 "2ac4d21635cdf791867bc377c35ca6dda7f50d919a58be45057fd51600c69aba"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://rsync.samba.org/ftp/rsync/?C=M&O=D"
    regex(/href=.*?rsync[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rsync"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "18af2c8e3eae39fc22d14c0c9096a9b05edc0e0b880fa337523dd8b3d2f136c8"
  end

  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.4
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.2.4.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.2.4.tar.gz"
    sha256 "70a597590af6c61cf3d05d663429ff9f60ffe24e44f9c73a4cdc69ebdc1322a4"
    apply "patches/fileflags.diff"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-rsyncd-conf=#{etc}/rsyncd.conf
      --with-included-popt=no
      --with-included-zlib=no
      --enable-ipv6
    ]

    # SIMD code throws ICE or is outright unsupported due to lack of support for
    # function multiversioning on older versions of macOS
    args << "--disable-simd" if MacOS.version < :catalina

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "a"
    mkdir "b"

    ["foo\n", "bar\n", "baz\n"].map.with_index do |s, i|
      (testpath/"a/#{i + 1}.txt").write s
    end

    system bin/"rsync", "-artv", testpath/"a/", testpath/"b/"

    (1..3).each do |i|
      assert_equal (testpath/"a/#{i}.txt").read, (testpath/"b/#{i}.txt").read
    end
  end
end
