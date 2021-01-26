class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Findomain/findomain/archive/3.0.1.tar.gz"
  sha256 "7bbedd088a64557876ccd7e7da92f1f8a5b67cfed1aaf335cd5d2b2a5f1824ad"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "d786858d2819476ffc1c3979fbb8fdd0d1cbb756123fb5376be13faf3d89a341" => :big_sur
    sha256 "16c9f1281a2a54952835423da396e41b4f3788273fa468eb74b7564fa20f0933" => :arm64_big_sur
    sha256 "290366f2319e32c716c817d2b86c184d879a4488495ae54f56e180e3c4d52fe2" => :catalina
    sha256 "eaf96a84962218711a7317249c0f6d0fd5a1156249e6e6ba1d3c53a236ec3fb7" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
