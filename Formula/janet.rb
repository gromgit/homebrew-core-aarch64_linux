class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.9.0.tar.gz"
  sha256 "30ca113843e597127912719a03a7da5f93fd1cf321245d8dbbcbae64d307ad5c"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "fe2367ff467e6083acbdbfc139a71737bfc08cc0227f5178e069b258175559b4" => :catalina
    sha256 "35fe589e74261385353445044fb32e19583a8bc92dd2b481f1a85f7502cc4f1f" => :mojave
    sha256 "550b00542de4d10d95bf2644df7af5b334246ec1de5815fce1b83ae4c0f1b57d" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  # should be removed in the next release
  patch do
    url "https://github.com/janet-lang/janet/commit/7275370ae563e8bfa7e907c9931bb1e0c88686d3.patch?full_index=1"
    sha256 "fcd581e38edfc89aef8c4164a7d36da0b55ce6965f85f01bca0ff92e1bf9019e"
  end

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
