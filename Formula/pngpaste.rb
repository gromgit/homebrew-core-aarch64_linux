class Pngpaste < Formula
  desc "Paste PNG into files"
  homepage "https://github.com/jcsalterego/pngpaste"
  url "https://github.com/jcsalterego/pngpaste/archive/0.2.3.tar.gz"
  sha256 "6221201cb05191855f0d2707ce7f4055f6e1330de8efc09d386be2a6629f543b"
  license "BSD-2-Clause"

  depends_on :macos

  def install
    system "make", "all"
    bin.install "pngpaste"
  end

  test do
    png = test_fixtures("test.png")
    system "osascript", "-e", "set the clipboard to POSIX file (\"#{png}\")"
    system bin/"pngpaste", "test.png"
    assert_predicate testpath/"test.png", :exist?
  end
end
