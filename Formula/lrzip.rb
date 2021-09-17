class Lrzip < Formula
  desc "Compression program with a very high compression ratio"
  homepage "http://lrzip.kolivas.org"
  url "http://ck.kolivas.org/apps/lrzip/lrzip-0.641.tar.xz"
  sha256 "2c6389a513a05cba3bcc18ca10ca820d617518f5ac6171e960cda476b5553e7e"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://ck.kolivas.org/apps/lrzip/"
    regex(/href=.*?lrzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7c23d8dcd60ab17f416775f444e70641305718f3f3966f87b63b204584221b91"
    sha256 cellar: :any,                 big_sur:       "e50e5a1b093feeec8ee1fb9bb3c4664cc80ceae210253ed2ec5b1a677dd2aa57"
    sha256 cellar: :any,                 catalina:      "15f270984b1591a12a87dc8698edb9be86df691f8081f204307a6176325a2b96"
    sha256 cellar: :any,                 mojave:        "c4fd1cfc9b09ab7f175bd056865c8712f9e6310c918cd03cfdf6e30f283c8761"
    sha256 cellar: :any,                 high_sierra:   "97797937ad456c0658fe24399dc757f30771e971647395fe1fefaa227f615fea"
    sha256 cellar: :any,                 sierra:        "b0c60e0773da9cf70d3164f362b3b527a7a87acd10b632291055d58ca2da7cfc"
    sha256 cellar: :any,                 el_capitan:    "c0ea3854495bd5d98f040f1a6b5a08e01857436aac25ead3f7a3fb44841f738a"
    sha256 cellar: :any,                 yosemite:      "345d0f65ddc44faab696c5e5bfabf6a6d408435858f49cfd630ee74e61f0c97c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2a34d339c06609f3c6db26a7101edbab08699014d06bb3e5886a7c610f534db"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build if Hardware::CPU.intel?
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Attempting to build the ASM/x86 folder as a compilation unit fails (even on Intel). Removing this compilation
    # unit doesn't disable ASM usage though, since ASM is still included in the C build process.
    # See https://github.com/ckolivas/lrzip/issues/193
    inreplace "lzma/Makefile.am", "SUBDIRS = C ASM/x86", "SUBDIRS = C"

    # Set nasm format correctly on macOS. See https://github.com/ckolivas/lrzip/pull/211
    inreplace "configure.ac", "-f elf64", "-f macho64" if OS.mac?

    system "autoreconf", "-ivf"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--disable-asm" unless Hardware::CPU.intel?

    system "./configure", *args
    system "make", "SHELL=bash"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lrz
    system bin/"lrzip", "-o", "#{path}.lrz", path
    path.unlink

    # decompress: data.txt.lrz -> data.txt
    system bin/"lrzip", "-d", "#{path}.lrz"
    assert_equal original_contents, path.read
  end
end
