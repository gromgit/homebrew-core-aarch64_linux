class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/0.1.28.1.tar.gz"
  sha256 "cbaded862d56d943c119630bf13974ef4370bb7fff533d244c9f42f7f5c5f3ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1c0fa0034e7e4d3c0ee7b57d839fbd423063074f85d5f1cb75618edbec5c143" => :catalina
    sha256 "347622daadd7af0f22ee353c79412839dfc786734a7974c53a2a92873702b75c" => :mojave
    sha256 "7a5ced2c1cfd68a1d95ce08d27ca3725575d8dff8837cb22227bef6c260a3a7d" => :high_sierra
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc/archive/197b42bd0e9268ec7c3c16526edc8530ad90a075.tar.gz"
    sha256 "a8319bc8b9a7683d798825deee7b2fdae944f2c53ff19024f75dd3472eeccd93"
  end

  def install
    resource("vc").stage do
      system ENV.cc, "-std=gnu11", "-w", "-o", buildpath/"v", "v.c", "-lm"
    end
    system "./v", "self"
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
