class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Edu4rdSHL/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/1.4.1.tar.gz"
  sha256 "53cf6a6920ce10c77f0f325dd6f0425a568be6369bf64ce3fbeed2efcbeefb1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "91188dbc6395b6577d863a50847a063a5970da957408b512919e5f1966deceb9" => :catalina
    sha256 "86ce4231cbdb6446e2e7cedc51665cd5e8d75ef929d6030ae6d42a7229ece9cd" => :mojave
    sha256 "3b1ae87e279a091b091885fd98c9e897e0ff12a80ea06953abd3f6c270a0572b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
