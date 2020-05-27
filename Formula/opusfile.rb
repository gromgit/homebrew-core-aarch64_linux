class Opusfile < Formula
  desc "API for decoding and seeking in .opus files"
  homepage "https://www.opus-codec.org/"
  url "https://archive.mozilla.org/pub/opus/opusfile-0.11.tar.gz"
  sha256 "74ce9b6cf4da103133e7b5c95df810ceb7195471e1162ed57af415fabf5603bf"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "acd200760db74feb30ea28bdb14cdf8b3ebdeb5a65759e1095fad3f9583c3ef3" => :catalina
    sha256 "44e1c4d26cac791ff40de7b15fb2718c6aaa99856a128c23a3c542a3132e2053" => :mojave
    sha256 "7f83ce800aaa0dedb44b18332e1628e307bf83d693586ed6359b02e6ea21737e" => :high_sierra
  end

  head do
    url "https://gitlab.xiph.org/xiph/opusfile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "openssl@1.1"
  depends_on "opus"

  resource "music_48kbps.opus" do
    url "https://www.opus-codec.org/static/examples/samples/music_48kbps.opus"
    sha256 "64571f56bb973c078ec784472944aff0b88ba0c88456c95ff3eb86f5e0c1357d"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testpath.install resource("music_48kbps.opus")
    (testpath/"test.c").write <<~EOS
      #include <opus/opusfile.h>
      #include <stdlib.h>
      int main(int argc, const char **argv) {
        int ret;
        OggOpusFile *of;

        of = op_open_file(argv[1], &ret);
        if (of == NULL) {
          fprintf(stderr, "Failed to open file '%s': %i\\n", argv[1], ret);
          return EXIT_FAILURE;
        }
        op_free(of);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["opus"].include}/opus",
                             "-L#{lib}",
                             "-lopusfile",
                             "-o", "test"
    system "./test", "music_48kbps.opus"
  end
end
