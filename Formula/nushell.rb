class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.25.1.tar.gz"
  sha256 "60a0e9967862b79b7323c2ce41760b59248b7a7c39a44a49cab47d3086ab2f0b"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ca665c6062b643bda9425b91c455a5035e7696a75dce19d7004759b3d7526bdb" => :big_sur
    sha256 "3f1cc8786bbf1022f0d102ec3adeebd889e45f99023cf42b7bb2bf5f9e4f067b" => :arm64_big_sur
    sha256 "dafcccd08e1bbe35b42a4191514195bc06020827ec3f42c29de0093444d0baf7" => :catalina
    sha256 "4ad72dd3b8908e0244d4d451ece42348f70458a29144030a5c759e8c1dda7a83" => :mojave
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
