class EbookTools < Formula
  desc "Access and convert several ebook formats"
  homepage "https://sourceforge.net/projects/ebook-tools/"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha256 "cbc35996e911144fa62925366ad6a6212d6af2588f1e39075954973bbee627ae"
  license "MIT"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ebook-tools"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0f8a4c60d46df61875ebbc9709df004a32bdb6558e17a9d1da4918ae95c9bf88"
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  uses_from_macos "libxml2"

  def install
    system "cmake", ".",
                    "-DLIBZIP_INCLUDE_DIR=#{Formula["libzip"].lib}/libzip/include",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/einfo", "-help"
  end
end
