class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # Note: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.1.29.tar.gz"
  sha256 "5111d04663d8454c9e8bcbd7e3544dcbd6abc54eb5034e31649417af6e8418a6"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "456016a58777fcd2be1889404913e41d9b72cc70db60d7b3034cb0b5f9c2c009" => :catalina
    sha256 "6bf3c73e0254ed784347aae365715ce683d79076cd48025a8e50ddf0096b1246" => :mojave
    sha256 "cf0602a48f187246fe9cd0546ba68f5a972b90186f8e4239162e863dac2ded68" => :high_sierra
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
      revision: "b01d0fcda4b55861baa4be82e307cca4834b1641"
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
