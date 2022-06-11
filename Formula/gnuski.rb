class Gnuski < Formula
  desc "Open source clone of Skifree"
  homepage "https://gnuski.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gnuski/gnuski/gnuski-0.3/gnuski-0.3.tar.gz"
  sha256 "1b629bd29dd6ad362b56055ccdb4c7ad462ff39d7a0deb915753c2096f5f959d"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gnuski"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "137adb543981c7cff9d1ef07aa4a8600e57ff65e7f3a689f10a32ca6e77fdd04"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "gnuski"
  end
end
