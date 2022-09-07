class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.5.0.tar.gz"
  sha256 "27833125a4097e15ec6dbce33e2798a1689a4674c0d0509c0dc1039204aa1d80"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/uni"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1e9c31df33193b702b3d0035f96f8dbf4d81018f71050745f9dc9373ac6b36f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"uni"
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
