class Rsync < Formula
  desc "Utility that provides fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://rsync.samba.org/ftp/rsync/rsync-3.2.0.tar.gz"
  mirror "https://mirrors.kernel.org/gentoo/distfiles/rsync-3.2.0.tar.gz"
  mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-3.2.0.tar.gz"
  sha256 "90127fdfb1a0c5fa655f2577e5495a40907903ac98f346f225f867141424fa25"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3e390c696ea20bad8bff15a1df7abc895e3fa2f2e4a11a055982799c21f8f19c" => :catalina
    sha256 "3eec6f49103c3d69ea6d6e85131f35814af318d11db02d04272ba4a842a52a55" => :mojave
    sha256 "cc355e9492df6bab4952e835dd8575de86fa169f6451218c5d2c777c4d9462a5" => :high_sierra
  end

  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "popt"
  depends_on "xxhash"
  depends_on "zstd"

  uses_from_macos "zlib"

  # hfs-compression.diff has been marked by upstream as broken since 3.1.3
  # and has not been reported fixed as of 3.2.0
  patch do
    url "https://download.samba.org/pub/rsync/src/rsync-patches-3.2.0.tar.gz"
    mirror "https://www.mirrorservice.org/sites/rsync.samba.org/rsync-patches-3.2.0.tar.gz"
    sha256 "bad70e6caad30ad12f0333529911b0f9c63f2ed096d6d649c2db2f6d9eec6e58"
    apply "patches/fileflags.diff",
          "patches/crtimes.diff"
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
    # function multiversioning on older verions of macOS
    args << "--disable-simd" if MacOS.version < :catalina

    # Fix assembly to build correctly on macOS. Issue already resolved upstream,
    # but source file has already been modified heavily since release, so applying
    # upstream patches would be cumbersome. Remove on next release.
    inreplace "lib/md5-asm-x86_64.s" do |s|
      s.gsub! ".type md5_process_asm,@function\n", ""
      s.gsub! ".L_md5_process_asm_end:\n" \
              ".size md5_process_asm,.L_md5_process_asm_end-md5_process_asm\n",
              ""
    end

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
