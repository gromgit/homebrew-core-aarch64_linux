class Gti < Formula
  desc "ASCII-art displaying typo-corrector for commands"
  homepage "https://r-wos.org/hacks/gti"
  url "https://github.com/rwos/gti/archive/v1.8.0.tar.gz"
  sha256 "65339ee1d52dede5e862b30582b2adf8aff2113cd6b5ece91775e1510b24ffb9"
  license "MIT"
  head "https://github.com/rwos/gti.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gti"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e7e1cc151d1d3cb9eff3b5c9baf6272b81d43c64732ce26487b40b4569f627b3"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "gti"
    man6.install "gti.6"
  end

  test do
    system "#{bin}/gti", "init"
  end
end
