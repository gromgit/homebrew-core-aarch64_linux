require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.5.tar.gz"
  sha256 "fea8ae40759d023baf39a89c5fdd157748d8d24591641c9d1b77106a28f1eb56"

  bottle do
    cellar :any_skip_relocation
    sha256 "d659ec48b4737eea12cafa7db3cbf4ef430246827b00b1a621376ccaa3fd8370" => :catalina
    sha256 "3a268374ec97cfe9f745c8e58e23ad7d1ebe3ef5dc8e6c3a81ea3097d84bd501" => :mojave
    sha256 "c6aa781abc7a8c87f5c376223bf46ad9a178131ce35e428beb1ee39ba77a99d6" => :high_sierra
  end

  def install
    system "make"
    bin.install "deark"
  end

  test do
    (testpath/"test.gz").write ::Base64.decode64 <<~EOS
      H4sICKU51VoAA3Rlc3QudHh0APNIzcnJ11HwyM9NTSpKLVfkAgBuKJNJEQAAAA==
    EOS
    system "#{bin}/deark", "test.gz"
    file = (testpath/"output.000.test.txt").readlines.first
    assert_match "Hello, Homebrew!", file
  end
end
