class Distrobox < Formula
  desc "Use any Linux distribution inside your terminal"
  homepage "https://distrobox.privatedns.org/"
  url "https://github.com/89luca89/distrobox/archive/refs/tags/1.3.1.tar.gz"
  sha256 "22b6625ca243f55c08630d37015cdbfbe1939516022bfef502aa6603f42b4d00"
  license "GPL-3.0-only"
  head "https://github.com/89luca89/distrobox.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/distrobox"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d716b6b03bcdd9e0e698d2870bc20b719e67aee6b2d1e98e3cf4c16aa905b080"
  end

  depends_on :linux

  def install
    system "./install", "--prefix", prefix
  end

  test do
    system bin/"distrobox-create", "--dry-run"
  end
end
