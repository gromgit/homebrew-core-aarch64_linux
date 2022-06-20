class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20220414.tgz"
  sha256 "493781718642cdd58bdba1cdf2a26776ca855908710d813bd2e93810dc49ece2"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dialog"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "eb565edff8415f1919677167bd9b61ed5e4f5b5cf6154d00b5a18ea61ad92e7a"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
