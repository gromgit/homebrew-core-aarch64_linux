class Scws < Formula
  desc "Simple Chinese Word Segmentation"
  homepage "https://github.com/hightman/scws"
  url "http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2"
  sha256 "60d50ac3dc42cff3c0b16cb1cfee47d8cb8c8baa142a58bc62854477b81f1af5"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/scws"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4b555302fe6a0a69f8cc11ee1834e63e5ed772eb7812764fecc50a5c4b5e589c"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/scws -c utf8 -i 人之初")
    assert_match "人 之 初", output
  end
end
