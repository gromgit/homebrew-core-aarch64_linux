class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.7/dateutils-0.4.7.tar.xz"
  sha256 "49725457f5bef45ea424baade8999a6e54496e357f64280474ff7134a54f599a"

  bottle do
    sha256 "d7a2e5a20d955be7a23c8fcbb3de9a3b83743243501340fcd57a8f3b8c6118b4" => :catalina
    sha256 "14c0bba42d725f246b116e5818ee421b8747b605aa4cc02dfaf00c863f821173" => :mojave
    sha256 "efcf8e592b8a3f76d73bcc0b4478323631f16554003c84ada8af2f92e5592dbc" => :high_sierra
    sha256 "c612ebbb2baffa30db4c1ba51afb635e406acd29cb0afec3329efbdf6dd419ae" => :sierra
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
    assert_equal "2012-03-01-00", output
  end
end
