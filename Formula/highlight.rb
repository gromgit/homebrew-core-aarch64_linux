class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-3.56.tar.bz2"
  sha256 "764942e25ebf6b2e07b3efa3bb073e1bb64091d1fd667d6d689091707558fa63"
  head "https://gitlab.com/saalen/highlight.git"

  bottle do
    sha256 "e1c8eb5a5f86e41a5c1686a1ad4bb9c25e9823eb281a034548c5a24cf10f41d8" => :catalina
    sha256 "0aa6c4d0ec14c94745fd457967e7a3abf2422ed481f42c3f33c8299649c34920" => :mojave
    sha256 "c68b53a6a2d7e08f4139c121a267178b0b2233f33b7251bb6849b3c3ec041d8f" => :high_sierra
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
