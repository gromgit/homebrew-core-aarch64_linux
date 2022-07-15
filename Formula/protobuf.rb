class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v21.2/protobuf-all-21.2.tar.gz"
  sha256 "9ae699200f3a80c735f9dc3b20e46d447584266f4601403e8fe5b97005f204dd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f4e5326f0b8505f31e9cf1d67e8fc088f9fd8c9b3cbc13da5f8795336bb5f46e"
    sha256 cellar: :any,                 arm64_big_sur:  "406101657c3c404d7a3e1d3a6ef05590ade52a6d9dfe4cd64c7ff600cb8fac78"
    sha256 cellar: :any,                 monterey:       "4b9161a1b48bb336f7688cb9acb7b19be036b87b59c9c75176ca5d480672c37c"
    sha256 cellar: :any,                 big_sur:        "c1731ca98919d87f8598ef295f36f9b1455e50fa9a7b3e8a56917c4331798f93"
    sha256 cellar: :any,                 catalina:       "77f8f708271676ee69abe5b2cea78b28fcf23803f6936add15f40ef0d45aef73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "389956d7ba144da578c25c55c1dd74e520ec59f62b90df1bca1d536389086cf6"
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
        site_packages = prefix/Language::Python.site_packages("python#{xy}")
        system "python#{xy}", *Language::Python.setup_install_args(prefix),
                              "--install-lib=#{site_packages}",
                              "--cpp_implementation"
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
