class Tcptunnel < Formula
  desc "TCP port forwarder"
  homepage "http://www.vakuumverpackt.de/tcptunnel/"
  url "https://github.com/vakuum/tcptunnel/archive/v0.8.tar.gz"
  sha256 "1926e2636d26570035a5a0292c8d7766c4a9af939881121660df0d0d4513ade4"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tcptunnel"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c59dcb627c6414a54a2ee00f380e26f2789e7c72a5b1325c5a46db0b05a1bbf2"
  end

  def install
    bin.mkpath
    system "./configure", "--prefix=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/tcptunnel", "--version"
  end
end
