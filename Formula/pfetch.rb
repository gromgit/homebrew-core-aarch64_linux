class Pfetch < Formula
  desc "Pretty system information tool written in POSIX sh"
  homepage "https://github.com/dylanaraps/pfetch/"
  url "https://github.com/dylanaraps/pfetch/archive/0.6.0.tar.gz"
  sha256 "d1f611e61c1f8ae55bd14f8f6054d06fcb9a2d973095367c1626842db66b3182"
  license "MIT"
  head "https://github.com/dylanaraps/pfetch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pfetch"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "aab8eaf9895d948032d3b57c9937ae201c7472f88913f01f83f7cb4800725a5c"
  end

  def install
    if build.head?
      bin.mkdir
      inreplace "Makefile", "install -Dm", "install -m"
      system "make", "install", "PREFIX=#{prefix}"
    else
      bin.install "pfetch"
    end
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
