class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.3.0.tar.gz"
  sha256 "c4f70bbae4c6afee3a524e65be31ae495201fd26687cb8429d7aded8be96306a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cgif"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4cbb125b5ca445420286b3356e3f6eac6d5e1d37f2b1000977d33272f7a76947"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Dtests=false"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"try.c").write <<~EOS
      #include <cgif.h>
      int main() {
        CGIF_Config config = {0};
        CGIF *cgif;

        cgif = cgif_newgif(&config);

        return 0;
      }
    EOS
    system ENV.cc, "try.c", "-L#{lib}", "-lcgif", "-o", "try"
    system "./try"
  end
end
