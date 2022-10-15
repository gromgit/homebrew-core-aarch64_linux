class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v2.1/tio-2.1.tar.xz"
  sha256 "6d3edda20ee0c9341fa4226a265e1a73527eb6685aa8d69e06c8390387c5332e"
  license "GPL-2.0-or-later"
  head "https://github.com/tio/tio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c44a9086b70f928b6bed0e05995cd1269ea3e7854bf6830f89424e4101239748"
    sha256 cellar: :any,                 arm64_big_sur:  "2fe5bf5d67925765082abd9a826945bece3402cec187f0f8eb9efd821f73ef5a"
    sha256 cellar: :any,                 monterey:       "8af522692b55d5c804d6dd303a6e666cd96b790681099bd06afd45abce8a0e01"
    sha256 cellar: :any,                 big_sur:        "e260e93b8fd8c9fce0db701d7fcad82dec6cdd5d648f87a3d91bf2cf3502f567"
    sha256 cellar: :any,                 catalina:       "186159ecc268dc404e1b09aa240f22b15f80d51d7487e95a5ed47d7bf5d19e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "179cedc1b4fb3d60a6a3d37815e253fff7267a8f6dabfadf90a6a0a443431053"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "inih"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    expected = "Error: Not a tty device"
    output = if OS.mac?
      shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
    else
      shell_output("script -q /dev/null -e -c \"#{bin}/tio /dev/null\"", 1).strip
    end
    assert_match expected, output
  end
end
