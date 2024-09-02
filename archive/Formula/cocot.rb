class Cocot < Formula
  desc "Code converter on tty"
  homepage "https://vmi.jp/software/cygwin/cocot.html"
  url "https://github.com/vmi/cocot/archive/cocot-1.2-20171118.tar.gz"
  sha256 "b718630ce3ddf79624d7dcb625fc5a17944cbff0b76574d321fb80c61bb91e4c"
  license "BSD-3-Clause"
  head "https://github.com/vmi/cocot.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cocot"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e3e2aa20ec0e772eabedf3d967af5d5a34a34c74a037b36d9398fe1e5c048da4"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
