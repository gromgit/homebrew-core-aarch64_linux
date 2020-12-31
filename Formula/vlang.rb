class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.2.1.tar.gz"
  sha256 "0e7d37e7ef7a5001b86811239770bd3bc13949a6489e0de87b59d9e50ea342c9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5b1c0aff3a00b1ed5280773f58cc7036e7c7815fe240801648991b8e7169d76a" => :big_sur
    sha256 "bd90ad78b6152fc2a96c75f9fbf3ee33b53286fa25253f370b180f58902d1dc5" => :arm64_big_sur
    sha256 "c76679206c70528a145c8624511ee53a2ad8aa075f0cc7ddbfec7e0540257bb1" => :catalina
    sha256 "6df40d00a41a8b6da2588c9dbfd111ed78e5a909f5ab1a1d5043cba8a78f9ed3" => :mojave
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "563c3bd5720e513326fbac728dde29454275de9d"
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
