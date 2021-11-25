class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/5.0.1.tar.gz"
  sha256 "8a235bdfd5c8e63cf077929b0c3d3e0d8d704370d72103b93e701c47e524c27b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c9041c9951e4bee8bec2cacdb53a7ee9bd0d80069e951b6ce639d0853992c89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65564e2fe089095d9d55761b9d883a2395131c1c3cf072db25555999dd04f8e8"
    sha256 cellar: :any_skip_relocation, monterey:       "54a85518b9883991b5d2d1f01abc45057f75fb667ac2f8204a3d415b8a11ea4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "11414804127bd42a112d01cc0a817b2b1987ae2acffc7ef25df1b9859a08dac0"
    sha256 cellar: :any_skip_relocation, catalina:       "f4cb544399f1d92d325551b3caaec9b9de590e932de43020d9bc5a28fce09e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3289284e97b4951040433194af545cb8f9946d2ed07717cb1f80d603ae5f43e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
