class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v19.12.13.103.tar.gz"
  sha256 "419bc4dd83c693cf9a19603ff1245186c9f76d4e057bdfd741987fd6ac620730"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "f6a81eb14ec6483d7309d85c4145f8a5e69f623c8e87d15783fc87448d1dd3ce" => :catalina
    sha256 "5cd7db73a38ff5f89836b1d11d479445ce71a2852c6e613899d9837bccf32b12" => :mojave
    sha256 "581ead45b63ea1dca579d2d47a514df8c313796d885e0b412c1af84972130601" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
