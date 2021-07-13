class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfssl.git",
      tag:      "v4.8.0-stable",
      revision: "add4a68465bcdad238bcf3e5f2771d8da05e6285"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfssl.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)[._-]stable["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ee955b5014b95136338e49c4ee70f244800e82a70365156382c8ba384e8524ec"
    sha256 cellar: :any,                 big_sur:       "694b28f4eebcc98de18f3d7bbb37d50d72da40e4b77580563d59b1202c98ebb3"
    sha256 cellar: :any,                 catalina:      "9d0128fb231075f80077d63995633716abf2d9d736ea024717b18828826ecc47"
    sha256 cellar: :any,                 mojave:        "6fce73d854f286e04fea290fb2bdc0e1d029501d983641b5f5334c180e148cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b0d8c5f137ab9dd9876c45fce28684d98291110d2e99d080bb80299b4ca3be"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-examples
      --disable-fortress
      --disable-md5
      --disable-sniffer
      --disable-webserver
      --enable-aesccm
      --enable-aesgcm
      --enable-alpn
      --enable-blake2
      --enable-camellia
      --enable-certgen
      --enable-certreq
      --enable-chacha
      --enable-crl
      --enable-crl-monitor
      --enable-curve25519
      --enable-dtls
      --enable-dh
      --enable-ecc
      --enable-eccencrypt
      --enable-ed25519
      --enable-filesystem
      --enable-hc128
      --enable-hkdf
      --enable-inline
      --enable-ipv6
      --enable-jni
      --enable-keygen
      --enable-ocsp
      --enable-opensslextra
      --enable-poly1305
      --enable-psk
      --enable-rabbit
      --enable-ripemd
      --enable-savesession
      --enable-savecert
      --enable-sessioncerts
      --enable-sha512
      --enable-sni
      --enable-supportedcurves
      --enable-tls13
      --enable-sp
      --enable-fastmath
      --enable-fasthugemath
    ]

    on_macos do
      # Extra flag is stated as a needed for the Mac platform.
      # https://www.wolfssl.com/docs/wolfssl-manual/ch2/
      # Also, only applies if fastmath is enabled.
      ENV.append_to_cflags "-mdynamic-no-pic"
    end

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
