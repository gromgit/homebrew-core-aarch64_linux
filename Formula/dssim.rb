class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.0.2.tar.gz"
  sha256 "5b1f3820709828310cd8d3145d7d45ccbc3db4cf8ab65e4c70ced4bcf17c8122"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "454288860d0a84578dc831b45e2c2edc901a5f9e275d5ecf26d88eb90f3a3f61"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1c5c83958163239faa9fc6be6df3b22b5b3f22e73d592550a0644673748bbaa"
    sha256 cellar: :any_skip_relocation, catalina:      "79e984e37783117cbc3923f5f5dc98ec8f65d0f9c550e64ce32135f48cbc04bb"
    sha256 cellar: :any_skip_relocation, mojave:        "78f969b1a8b31bd99305cc9b43e91e3e2e5c39f71ed4083fd7bfbcfcef36a00c"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
