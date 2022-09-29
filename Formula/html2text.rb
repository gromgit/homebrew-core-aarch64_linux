class Html2text < Formula
  desc "Advanced HTML-to-text converter"
  homepage "http://www.mbayer.de/html2text/"
  url "https://github.com/grobian/html2text/archive/v2.1.1.tar.gz"
  sha256 "be16ec8ceb25f8e7fe438bd6e525b717d5de51bd0797eeadda0617087f1563c9"
  license "GPL-2.0-or-later"
  head "https://github.com/grobian/html2text.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/html2text"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e6df4678bbedbf0fc55491a529d94515e9ac4b9850b9d7f656bb7b01bfac88f9"
  end

  def install
    ENV.cxx11

    system "./configure", *std_configure_args
    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}", "BINDIR=#{bin}", "MANDIR=#{man}", "DOCDIR=#{doc}"
  end

  test do
    path = testpath/"index.html"
    path.write <<~EOS
      <!DOCTYPE html>
      <html>
        <head><title>Home</title></head>
        <body><p>Hello World</p></body>
      </html>
    EOS

    output = `#{bin}/html2text #{path}`.strip
    assert_equal "Hello World", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
