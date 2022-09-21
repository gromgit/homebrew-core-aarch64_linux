class Scale2x < Formula
  desc "Real-time graphics effect"
  homepage "https://www.scale2x.it/"
  url "https://github.com/amadvance/scale2x/releases/download/v4.0/scale2x-4.0.tar.gz"
  sha256 "996f2673206c73fb57f0f5d0e094d3774f595f7e7e80fcca8cc045e8b4ba6d32"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/scale2x"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "735d37820d2505fe2732920691affdb3d33b15e322e8dedc41adb999c109cacb"
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}", "CPPFLAGS=-I/usr/include/malloc/"
    system "make", "install"
  end
end
