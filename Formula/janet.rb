class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.15.0.tar.gz"
  sha256 "e2cf16b330e47c858a675ac79b5a0af83727ff041efcb133a80f36bedfae57c4"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "46ae27b110fdef6d333d44d10632fead02c88da4bfbbb7a3b625a5b263acba15"
    sha256 cellar: :any, big_sur:       "831ee848dfaf6e45611274dbaefd5f0debc1202936369b79daf7c55e927de3a4"
    sha256 cellar: :any, catalina:      "9b020b08ab6756c1c33f980d850fd9eee05c917edce2d6ccf28e87f30db899dd"
    sha256 cellar: :any, mojave:        "91c5ad4566064f72604943b2268fd0434790525324ccf073048519c07da42fd5"
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
