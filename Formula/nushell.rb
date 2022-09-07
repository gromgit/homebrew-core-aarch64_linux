class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.68.0.tar.gz"
  sha256 "c170ce2a0fa931194c8169585608747fea0cbf7c957f67c6e2fd54c0c5071c64"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e0e9d4046cbf3bd7574389fdc734416dc727d834d7f40cf0daa7d402c80a09d0"
    sha256 cellar: :any,                 arm64_big_sur:  "270932aa7eed448345f44689e2c464eed6f7805aea53c67763e3cea573b754fc"
    sha256 cellar: :any,                 monterey:       "b30e10a0c1c36844ef36fde88aaec5f9b1d05095c5c59d2cdbc5b647df1152a4"
    sha256 cellar: :any,                 big_sur:        "56373cdfbd2de9cb665fae639cf7825afb6c58d9da21969d3cbdce0da3a28ff8"
    sha256 cellar: :any,                 catalina:       "273d230832915bbb59e8cd822d8897f9fe1a25624db319010a570145da77f488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "513d5580745fa611317d7ef074870355ae7844c9d7717e09f12ee0063163931f"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end
