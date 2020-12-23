class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.22/newsboat-2.22.tar.xz"
  sha256 "5286f815d9a00b4752a5572d99bbd9bc512b69c06931453faa415968881cd790"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 "f164d271561e0e186e312555f68d861d4f02d7e73f768dc01f24a86002318379" => :big_sur
    sha256 "b6e3e9a12a9a2c130f473202de2e83b0983ae350b078ed8e896853633d6b86b0" => :catalina
    sha256 "74574b9b32aaef33fbdd94fcaaeee643ab55e6ff5b92aa72700b418340365f29" => :mojave
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    gettext = Formula["gettext"]

    ENV["GETTEXT_BIN_DIR"] = gettext.opt_bin.to_s
    ENV["GETTEXT_LIB_DIR"] = gettext.lib.to_s
    ENV["GETTEXT_INCLUDE_DIR"] = gettext.include.to_s
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
