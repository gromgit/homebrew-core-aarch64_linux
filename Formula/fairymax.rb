class Fairymax < Formula
  desc "AI for playing Chess variants"
  homepage "https://www.chessvariants.com/index/msdisplay.php?itemid=MSfairy-max"
  url "http://hgm.nubati.net/git/fairymax.git",
      tag:      "5.0b",
      revision: "f7a7847ea2d4764d9a0a211ba6559fa98e8dbee6"
  version "5.0b"
  head "http://hgm.nubati.net/git/fairymax.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fairymax"
    sha256 aarch64_linux: "0ffebfc2cad8c068fcc91f2a0c8ab5857e0c4372e36adc4b1854f58462ca4f37"
  end

  def install
    system "make", "all",
                   "INI_F=#{pkgshare}/fmax.ini",
                   "INI_Q=#{pkgshare}/qmax.ini"
    bin.install "fairymax", "shamax", "maxqi"
    pkgshare.install Dir["data/*.ini"]
    man6.install "fairymax.6.gz"
  end

  test do
    (testpath/"test").write <<~EOS
      hint
      quit
    EOS
    system "#{bin}/fairymax < test"
  end
end
