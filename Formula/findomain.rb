class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/1.6.0.tar.gz"
  sha256 "8d184977581ef4f3aae396db168eaed4b4a0512b149b31e448bf9c97964f27ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "f330ec2e05591c6b05238a3222e0f1738bc851290638ab73615171a34fa66368" => :catalina
    sha256 "b216aad85034866c4afa3653ebe052e0cae4076f0a8c641dfb49ffa4e5dccac9" => :mojave
    sha256 "15adabae41e3d026fa8d1989521803c93a2698b2e9477221e684a1bbcd82b409" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
