class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.25.0.tar.gz"
  sha256 "31e8a121d38cf6386090cea7e96ac72b22ed41ceca2bdf0e7eb65f7741ab67b3"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "3fd215ea0b1c8512b6c272107dcb48e76adce1733b0c6d4a495f2243d847fea3" => :big_sur
    sha256 "63a8799e77505de86e40b8bd635bf75039b2ec1e32a1859b20003f4d185c3bfe" => :arm64_big_sur
    sha256 "81c226684e631321762d3941b11e9709a26123240af30561f74ab3e9661e246e" => :catalina
    sha256 "d9df76bfc701753b76981b950b2cd5d93740fca0df876fae72fe000322bb9f0c" => :mojave
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--features", "stable", *std_cargo_args
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu", 'echo \'{"foo":1, "bar" : "homebrew_test"}\' | from json | get bar')
  end
end
