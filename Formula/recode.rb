class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.8/recode-3.7.8.tar.gz"
  sha256 "4fb75cacc7b80fda7147ea02580eafd2b4493461fb75159e9a49561d3e10cfa7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "61083b9e7eaab6ba33d88958e10d14e08173bbc62b5c1b4d0e7eaa47d62e8ddb" => :big_sur
    sha256 "104914c7dd2db1afbafe61a025ebe41da5a88ed89ac8079c8e7d9150bb7a2e2d" => :catalina
    sha256 "541408c872b2c16e999cb6f74fc94e8c340dfb1e2eb3a89aa21d3f118554219d" => :mojave
    sha256 "65d9921e28f36fe7a0755d1cab44e4c2d2e5752ab25ed6c35cc7ee9e9072aee3" => :high_sierra
    sha256 "d8d1838e5484c1bbdde1a1f4f57907a601ee32b6577c3c9364dde06e095a5605" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "python@3.9" => :build
  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
