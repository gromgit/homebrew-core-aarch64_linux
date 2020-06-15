class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.10.0.tar.gz"
  sha256 "b12b2609ab69a2e681446e44368e3b72bdad15b550471365fd8580e2265d3389"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "aa13af05341ba304e1534146ab3af054f23e9371215ede439bfbfd1d70ce9201" => :catalina
    sha256 "c1491e35d42366a61b72ecf4e3b7b1245f52e4845f70a982d0bc9ec6b98eff63" => :mojave
    sha256 "cd120c39040814620ecebd6788b9f7463c775410c2eff6d49fd9cdd8fdcf9706" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "--buildtype=release", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
