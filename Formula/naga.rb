class Naga < Formula
  desc "Terminal implementation of the Snake game"
  homepage "https://github.com/anayjoshi/naga/"
  url "https://github.com/anayjoshi/naga/archive/naga-v1.0.tar.gz"
  sha256 "7f56b03b34e2756b9688e120831ef4f5932cd89b477ad8b70b5bcc7c32f2f3b3"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/naga"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "634313e1de01b5b35e07743f5ee33b9c66d1ce80335e91f96495dada931f7316"
  end

  uses_from_macos "ncurses"

  def install
    bin.mkpath
    system "make", "install", "INSTALL_PATH=#{bin}/naga"
  end

  test do
    assert_predicate bin/"naga", :exist?
  end
end
