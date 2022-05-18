class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.10.0.tar.gz"
  sha256 "a74294c42274f31e3e9c7d116156aa0c0b03508e656a5eb5b31b119dc45fc884"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d882c4393aa264b601b0292195d8238d6e0a0a51a7ca20f42852af6eca4aa02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "972985d924b37ba2d87bb60c4a02cf3a45a7650c4178cb9b6d447d050b931087"
    sha256 cellar: :any_skip_relocation, monterey:       "ac50fc24ed2c0524383e5901d1a9401e56b520b3edc3969fddac35ba550f89c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4ee3b05f15ef0b87011a360ff3352495a85beea65a5764c6d65e3550286e967"
    sha256 cellar: :any_skip_relocation, catalina:       "3a1fb3c132388f4c209c1ecbe1487967b961ee2655a47240940906d2c9d3e209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "613abbc2a1e358aba9a1f8e9ff4bb6e4d664c0905081f2eda8dc30345b40e9f4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
