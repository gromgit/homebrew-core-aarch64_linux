require "base64"

class Deark < Formula
  desc "File conversion utility for older formats"
  homepage "https://entropymine.com/deark/"
  url "https://entropymine.com/deark/releases/deark-1.5.6.tar.gz"
  sha256 "716bc1c2c0d6e40a34a1edec62bc1e93d14c6b70c9657d977d7415783009a278"

  livecheck do
    url "https://entropymine.com/deark/releases/"
    regex(/href=.*?deark[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f8d53f955cfd1e3e506c9db344479771a29d4a59408a845dcf58fa3c13f21641" => :catalina
    sha256 "950b65739f9a3770e1e98ef497aef22a529f31aff07186e287dc41764ca8086f" => :mojave
    sha256 "a66a4003564df921fd305c02fc9a2996093780365841a615615f953946f2b37d" => :high_sierra
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
