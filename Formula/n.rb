class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.4.1.tar.gz"
  sha256 "68364cc0a3b84254ef61d8c1e86cfc17110984daceb22df4dca28cd40341b589"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d98eb65e495bdb70e93f83b38250b481154e32aca63d976962159af3c44cec2"
    sha256 cellar: :any_skip_relocation, big_sur:       "1ccc72bec6169bc2a660c7100438132266e0bfcf441775306acac3d6322351ba"
    sha256 cellar: :any_skip_relocation, catalina:      "1ccc72bec6169bc2a660c7100438132266e0bfcf441775306acac3d6322351ba"
    sha256 cellar: :any_skip_relocation, mojave:        "1ccc72bec6169bc2a660c7100438132266e0bfcf441775306acac3d6322351ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d98eb65e495bdb70e93f83b38250b481154e32aca63d976962159af3c44cec2"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
