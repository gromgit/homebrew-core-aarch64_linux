class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.66.2.tar.gz"
  sha256 "548668fe0e746cb068443b7701829e1839565e30aa5faa20c5481d0ead808045"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "85194a24d86dfce12fe76bf5c3e6226c36524ae9133b9cabfc0541d996b9f6d8"
    sha256 cellar: :any,                 arm64_big_sur:  "f952c2397b745a5fa059b158bb9960889cfdb7f866f577595a47e0240a5a2383"
    sha256 cellar: :any,                 monterey:       "bcaabbe28403aa4924e0594d695ed5fd90e30f1e0c00b507b4f7eb7800d49373"
    sha256 cellar: :any,                 big_sur:        "20a33791b0e9d3fa4e936ffd08be791d35e503f1361d593e7bcb9ada3c2ac4ad"
    sha256 cellar: :any,                 catalina:       "632282c75d795755d4602cadc081892487fad8c2ffe90d22aa044126e14c8b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1c5720b663a6a6c7a41b58c257ca81050feff57bf70f52f3dd329612c0435b"
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
