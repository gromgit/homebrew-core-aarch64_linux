class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.59.tar.bz2"
  sha256 "85926ca8e08e69b497fa4a0c93bec595e15c1ca18c4ee494ea3f1c9a78c249a2"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "81d79baca076097bd593e6d4376f26e1d6153138664ad9cb7cf6b08bcf80fb98" => :catalina
    sha256 "7b33c97698d9ef044fddfe1a579b2c8628970c29b4502c839524a2fafcbe1224" => :mojave
    sha256 "ed1984aab59c16059e508959be04cf5ec88b68718c06720dfd5f802d8ef81bfd" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end
