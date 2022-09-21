class Jansson < Formula
  desc "C library for encoding, decoding, and manipulating JSON"
  homepage "https://digip.org/jansson/"
  url "https://github.com/akheron/jansson/releases/download/v2.14/jansson-2.14.tar.gz"
  sha256 "5798d010e41cf8d76b66236cfb2f2543c8d082181d16bc3085ab49538d4b9929"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jansson"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "acbaeda024e2c900de9c3fcaf5c2cf5a05c3dcbad023522ba78de90904e6cc5e"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <jansson.h>
      #include <assert.h>

      int main()
      {
        json_t *json;
        json_error_t error;
        json = json_loads("\\"foo\\"", JSON_DECODE_ANY, &error);
        assert(json && json_is_string(json));
        json_decref(json);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ljansson", "-o", "test"
    system "./test"
  end
end
