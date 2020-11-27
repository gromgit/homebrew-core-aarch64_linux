class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.35.0/mk-configure-0.35.0.tar.gz"
  sha256 "7487cb26969f3e8f155c2a4d1b7d75599c60d593c10917462c1b505fa5a53bc1"

  livecheck do
    url :stable
    regex(%r{url=.*?/mk-configure[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5bc4a9bc45792bed751f3dc08ec1c0e73885c15f3e33c66c80bccfff913120e1" => :big_sur
    sha256 "46eeafa552c407c5e43ef5ff9fe17331e047063e96c7e4c422ca81e60e448477" => :catalina
    sha256 "d79a5855774a12a0729cd3f18c4fa623a6b0263e89dc83a7b97a31843bc1980f" => :mojave
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
