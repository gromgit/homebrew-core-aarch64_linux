class Mdzk < Formula
  desc "Plain text Zettelkasten based on mdBook"
  homepage "https://mdzk-rs.github.io"
  url "https://github.com/mdzk-rs/mdzk/archive/0.4.2.tar.gz"
  sha256 "cb4f86b4b7c6b085fe4e78abaf0ad9085c95ec253f89d861bb3397d103e77fc6"
  license "MPL-2.0"
  head "https://github.com/mdzk-rs/mdzk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6586ca17bd0b2b6fa453002173567aaea6e380d08a2384eaf8838aa06c3a894f"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cee4906ef3d28f8c5b982efb01741f3df84e4ae696881df63625dee987dec40"
    sha256 cellar: :any_skip_relocation, catalina:      "ca2a36b65759c882af7e96df2d137ff849a6fd25063b53bfb4b6d9636cb621ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "818313ca090f696f78045c22d0818afd0867689b6ba2b04e937d2c9305e4fb1c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/mdzk", "init", "test_mdzk"
    assert_predicate testpath/"test_mdzk", :exist?
  end
end
