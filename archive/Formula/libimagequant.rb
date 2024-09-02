class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.0.4.tar.gz"
  sha256 "d121bbfb380a54aca8ea9d973c2e63afcbc1db67db46ea6bc63eeba44d7937c8"
  license :cannot_represent

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libimagequant"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0bb3935252891a640b259eab8db50ba167b90df43219f10d8f69a5c5acd8e8a7"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    cd "imagequant-sys" do
      system "cargo", "cinstall", "--prefix", prefix
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libimagequant.h>

      int main()
      {
        liq_attr *attr = liq_attr_create();
        if (!attr) {
          return 1;
        } else {
          liq_attr_destroy(attr);
          return 0;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end
