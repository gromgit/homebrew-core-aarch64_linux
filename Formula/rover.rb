class Rover < Formula
  desc "CLI for managing and maintaining data graphs with Apollo Studio"
  homepage "https://www.apollographql.com/docs/rover/"
  url "https://github.com/apollographql/rover/archive/v0.8.0.tar.gz"
  sha256 "9be1392545d3e50f74c7c3f12b101248285b1d3658c51e7541d22c4626ecfce1"
  license "MIT"
  head "https://github.com/apollographql/rover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ac00e0c8d06abd182f43ec35bffc2820559f60aeb9a8ed0d163c86511dcbad3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21f398e14823a077be8d2a9a08bc0a37645c6a6dbc00a852d275c1795e9c8ea9"
    sha256 cellar: :any_skip_relocation, monterey:       "1316817da978952466178b1c883ac370ab9ef091b27677405ae00f13eedfbf7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e15ae8e4ca72171cdf2804267a88d4af73c36d86714706d52b728103d042f6d2"
    sha256 cellar: :any_skip_relocation, catalina:       "8e422120b530996d36e10694edb57149c2dcae9483229b6697a3f5f1a5416791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "215bdc4e753af6d58ea001696a5266245c00636df1c7478946fbf5ea97d9c1c3"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rover graph introspect https://graphqlzero.almansi.me/api")
    assert_match "directive @cacheControl", output

    assert_match version.to_s, shell_output("#{bin}/rover --version")
  end
end
