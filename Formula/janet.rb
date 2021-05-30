class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.16.0.tar.gz"
  sha256 "84f83b356055557d668dd328a4242bbc652d3cb39e8431666ce391248f4c20e4"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ec16ee1e2ded528b92cadd5858932f932187c12859f689b02ae33fe1cc2b9667"
    sha256 cellar: :any, big_sur:       "bb390d24bde6f00538bf80374b3c2c02bf445fa1f467adcffc10fff57db509f9"
    sha256 cellar: :any, catalina:      "a670cf1b0a7870347747b8636dff8731467a8a6d5a64120bd33c0314ea84271a"
    sha256 cellar: :any, mojave:        "cef2ce04117d9aa2e531ca9cd1eeab9c3c3ee0d0d32eec705f2a683e970da7b5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
