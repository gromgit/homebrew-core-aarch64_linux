class Lunzip < Formula
  desc "Decompressor for lzip files"
  homepage "https://www.nongnu.org/lzip/lunzip.html"
  url "https://download-mirror.savannah.gnu.org/releases/lzip/lunzip/lunzip-1.13.tar.gz"
  sha256 "3c7d8320b947d2eb3c6081caf9b6c91b12debecb089ee544407cd14c8e517894"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lunzip/"
    regex(/href=.*?lunzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lunzip"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8adcc07665c6159385d7df66a64c251a73a991c00230723afa937ff740a76852"
  end

  depends_on "lzip" => :test

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.lz
    system Formula["lzip"].opt_bin/"lzip", path
    refute_predicate path, :exist?

    # decompress: data.txt.lz -> data.txt
    system bin/"lunzip", "#{path}.lz"
    assert_equal original_contents, path.read
  end
end
