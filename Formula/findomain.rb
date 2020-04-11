class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/1.5.0.tar.gz"
  sha256 "c0a92be44849b5530ea218a220018f486c1bc48cf176c996fe53ddf8e030c372"

  bottle do
    cellar :any_skip_relocation
    sha256 "0aa0e6298888f5cc5746477f810e14d89e1304009ddd1a1a055b1fd9f170868d" => :catalina
    sha256 "855ebef722c4fbee41ea8395640a15ea78bea9a399a4fb3bdd05e8fa84275ebd" => :mojave
    sha256 "a0c2ef9001d434e738c6ae031aaa33c7bec0bce9b852d707d9175a81011b30ff" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
