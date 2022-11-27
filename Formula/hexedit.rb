class Hexedit < Formula
  desc "View and edit files in hexadecimal or ASCII"
  homepage "http://rigaux.org/hexedit.html"
  url "https://github.com/pixel/hexedit/archive/1.6.tar.gz"
  sha256 "598906131934f88003a6a937fab10542686ce5f661134bc336053e978c4baae3"
  license "GPL-2.0-or-later"
  head "https://github.com/pixel/hexedit.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hexedit"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e527b34cffb89bd6217ce6d0b7d683c07e7457c29b952063174a1bfec8d27bd3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/hexedit -h 2>&1", 1)
  end
end
