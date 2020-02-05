class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/1.3.0.tar.gz"
  sha256 "6393b173464e3eb10c0a86ada4b337302e4bbc772afd0aa59eafd5be7ae0d616"

  bottle do
    cellar :any_skip_relocation
    sha256 "9485ab03c88d96be60a6745533e1cbeeb349563301580db253cc83b95ad975c8" => :catalina
    sha256 "dc3008469ed23ee373aa697f53b31afb94a9e0f0c6635c99d95c6d8813900b13" => :mojave
    sha256 "947f82536ccf9f22709ed31cf4d3e2fb3d601ecfb1fdd6b1c05700f98ac5db35" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
