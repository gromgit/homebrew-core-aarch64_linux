class Cgif < Formula
  desc "GIF encoder written in C"
  homepage "https://github.com/dloebl/cgif"
  url "https://github.com/dloebl/cgif/archive/refs/tags/V0.0.4.tar.gz"
  sha256 "44928be23dee6c57f98516813926e02c7edf84dde9dc06931c5513b5d3847936"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "96d6aae53ce9d259b03cb065bbc3f09b4b521609b31c5d4fa0e725b25fa28183"
    sha256 cellar: :any,                 arm64_big_sur:  "2f52a225a1b6b8d3a3f77d76da5d7573b1bffbb25515b010febef0c750d3855a"
    sha256 cellar: :any,                 monterey:       "f4741c2bd68c17d3e58d2d9266187f65f590553fdff9d9bb54216cf15e0ef72a"
    sha256 cellar: :any,                 big_sur:        "8b411552427ad32078ec39ddf165b8b24ad8a690f5528f65d7b887986cc0fada"
    sha256 cellar: :any,                 catalina:       "a5abf85e2441726011e3066b5f6cd70851051aac0694134fca25e4787d8f76c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecf40e2c1694cf13ca34d1cd85e248aa995ae0b5df153e8c6853373d37edd76a"
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
