class Vtclock < Formula
  desc "Text-mode fullscreen digital clock"
  homepage "https://github.com/dse/vtclock"
  url "https://github.com/dse/vtclock/archive/0.0.20161228.tar.gz"
  sha256 "0148411febd672c34e436361f5969371ae5291bdc497c771af403a5ee85a78b4"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/dse/vtclock.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vtclock"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cc3b0d5eaf252b321080b01b5bb165295250cf0ae2a1d031e17e115c7918295f"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "ncurses"

  def install
    system "make"
    bin.install "vtclock"
  end

  test do
    system "#{bin}/vtclock", "-h"
  end
end
