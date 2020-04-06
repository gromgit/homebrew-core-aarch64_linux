class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.34.1/mk-configure-0.34.1.tar.gz"
  sha256 "1eb4fa2ba669f8e9d24bc4baadcb9717ea8a75c943c2c13760fd9b0fb74c6108"

  bottle do
    cellar :any_skip_relocation
    sha256 "59cb3bc8e8c34490e50d3d8ffee35db5c6f5ec3b2d452d773fdd3a35ad2f864e" => :catalina
    sha256 "59cb3bc8e8c34490e50d3d8ffee35db5c6f5ec3b2d452d773fdd3a35ad2f864e" => :mojave
    sha256 "9dfe100ba1a66a267d791a986831ce2856db6e074394c3e65fb80c679c19c584" => :high_sierra
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
