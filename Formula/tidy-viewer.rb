class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.3.tar.gz"
  sha256 "e308eb088d059d18119dc757c98487d9cabc2f4b97035a8dc9f8253717aa9fe9"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7326e50cbfebb23342dc968d536a73509ef11d397a21edd419ae4cfa5e8047b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0358924f7971448a28ee5be4fb0b82f991b545fba2108527e170c318a14ccad1"
    sha256 cellar: :any_skip_relocation, monterey:       "84ea450d6cfdff253b5182c0855393e27f92ca815cf1fec4cb5aa6883079418a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d81df09c4b19e0e4942673bca857dd1a79f75215b63b25ad7332458abd458d9a"
    sha256 cellar: :any_skip_relocation, catalina:       "12bde2da95e4ec056b625f8b6e6944b7fe4a756380da8f63a8367708d80600bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ba6f04d0b3f58f04538dac36c2551b52ec0bda96f80a61335f76454aeef93f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end
