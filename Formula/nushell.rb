class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.66.0.tar.gz"
  sha256 "f275479b41b8fe94e49907955f38a6c448d5d3bb11628930b3141340efea02a5"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fe751e6d7192c545ab9182990c0e53e002fcffccd3552499144ae913b64f1f92"
    sha256 cellar: :any,                 arm64_big_sur:  "9e6bb8af85a19b32d09324baba70be3d3f2e5d2a706faf2259492af9e852b8a9"
    sha256 cellar: :any,                 monterey:       "a6c6f072973125c9192f06df41768c1949aed7ad7fb454ebf51d7f911e6ff39a"
    sha256 cellar: :any,                 big_sur:        "8659b587dc3976a80508bff0f40882a424a68d55b3cae6a4f39279395615eb56"
    sha256 cellar: :any,                 catalina:       "bb8ede93808ccef9bc25acf403148f2d0b75452e3796c234e48e856dbe972145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbc616c4234a49494a8c0534d41c4963f84692e978f7e2a8799a2457ddfbb981"
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
