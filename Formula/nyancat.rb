class Nyancat < Formula
  desc "Renders an animated, color, ANSI-text loop of the Poptart Cat"
  homepage "https://github.com/klange/nyancat"
  url "https://github.com/klange/nyancat/archive/1.5.2.tar.gz"
  sha256 "88cdcaa9c7134503dd0364a97fa860da3381a09cb555c3aae9918360827c2032"
  license "NCSA"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nyancat"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "32bad595b1669f71acf5661a66f720460c2910378fa61928babd43129f8f9f4b"
  end

  # Makefile: Add install directory option
  # See https://github.com/klange/nyancat/pull/34
  patch do
    url "https://github.com/klange/nyancat/commit/e11af77f2938ea851f712df62f08de4d369598d4.patch?full_index=1"
    sha256 "24a0772d2725e151b57727ce887f4b3911d19e875785eb7e13a68f4b987831e8"
  end

  def install
    system "make"
    system "make", "install", "instdir=#{prefix}"
  end

  test do
    system bin/"nyancat", "--frames", "1", "--width", "40", "--height", "20", "--no-clear"
  end
end
