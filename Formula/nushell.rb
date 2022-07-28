class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.66.1.tar.gz"
  sha256 "30eb93ca403c2261dec7b483b2fe03c462821177f78c0b6bb996550feb5eac8d"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bfab7f9a5e293664d4dcdea7b8fdb7689fac96567d261df098ded6e2399d3cde"
    sha256 cellar: :any,                 arm64_big_sur:  "ffa709404eaceac517942d0f2263a7962ef7581323e5a99b17551829c7e00f86"
    sha256 cellar: :any,                 monterey:       "e89af1d2875a978b026385576b55393642141962c108a8d985b061f7b86f00b8"
    sha256 cellar: :any,                 big_sur:        "3fde3d19f8406c59560f7afdf656417ade1f212a1e59cf9499c25b7551b7eace"
    sha256 cellar: :any,                 catalina:       "d0bb5bd05126f823bd18e03659be1731fdf5bf8f73a04b858a6e20b6b2f5250c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48480a90c5e7c5eb9e310abf836dde2fe19047491f902584226d9b8b45486a48"
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
