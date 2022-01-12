class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.19.3/protobuf-all-3.19.3.tar.gz"
  sha256 "84cca73ed97abce159c381e682ba0237bc21952359b07d8d45dc7e6399edd923"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f122e809592df08a909c7d3734f4465c72f91e810a94763f1109cdbbe56c9263"
    sha256 cellar: :any,                 arm64_big_sur:  "32e803cab25eba87d46820ed672dd16e64c586b3e6127c6fc492489477e4655b"
    sha256 cellar: :any,                 monterey:       "d114e3895ae26496f6939cfb7926c9536a636ba369a62541dfbaa7328bf90195"
    sha256 cellar: :any,                 big_sur:        "8922f3c0b2cfa6a4f4e1810b7a22ff8887489a26d65dc84d2a1841d13854e62e"
    sha256 cellar: :any,                 catalina:       "4405f9ea2271adb38d4a0fe9dcf5c160a46c14e66a1a71ae8cd57aa58afe2b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd5c8aaadc4639176cf9aab1f6474038afecf26a63ed3b58dd49ca18bd7866d6"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10" => [:build, :test]
  # The Python3.9 bindings can be removed when Python3.9 is made keg-only.
  depends_on "python@3.9" => [:build, :test]
  depends_on "six"

  uses_from_macos "zlib"

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    cd "python" do
      ["3.9", "3.10"].each do |xy|
        system "python#{xy}", *Language::Python.setup_install_args(prefix), "--cpp_implementation"
      end
    end
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import google.protobuf"
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import google.protobuf"
  end
end
