class HtRust < Formula
  desc "Yet another HTTPie clone"
  homepage "https://github.com/ducaale/ht"
  url "https://github.com/ducaale/ht/archive/v0.6.0.tar.gz"
  sha256 "a990e2973cd62cc483dc875e5ee880bfdd759e73f8e6ccf63b188092f7d9f293"
  license "MIT"
  head "https://github.com/ducaale/ht.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "42e41db3b9bd2a0d0d7597c54c16f89acbcb1edac3e8ea0104b2718d50602a51"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc36d8cbe1cddc8370124aca0f251bf7fce343dc98ea3ec22498bb1e2b0d0b46"
    sha256 cellar: :any_skip_relocation, catalina:      "456c9143ebada5edb6c38978afb81b8b760bb52b247e3ab4dbbab99e68d47ee9"
    sha256 cellar: :any_skip_relocation, mojave:        "7be77418ed74378806d03f48dd48b4dc26917dcec56c216c052f3905b8544a7a"
  end

  depends_on "rust" => :build

  conflicts_with "ht", because: "both install `ht` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/ht -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end
