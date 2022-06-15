class Lpc21isp < Formula
  desc "In-circuit programming (ISP) tool for several NXP microcontrollers"
  homepage "https://lpc21isp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/lpc21isp/lpc21isp/1.97/lpc21isp_197.tar.gz"
  version "1.97"
  sha256 "9f7d80382e4b70bfa4200233466f29f73a36fea7dc604e32f05b9aa69ef591dc"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lpc21isp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "43d9a68eea9aa9ac7709e92fbcabbeb9b7051e3239b6750b4494eb0b1750867f"
  end

  def install
    system "make"
    bin.install ["lpc21isp"]
  end
end
