class Ansifilter < Formula
  desc "Strip or convert ANSI codes into HTML, (La)Tex, RTF, or BBCode"
  homepage "http://www.andre-simon.de/doku/ansifilter/ansifilter.html"
  url "http://www.andre-simon.de/zip/ansifilter-2.16.tar.bz2"
  sha256 "7fcd2fa3520bce2bd3834c299f533cbfb43a29a095c83e8fea372a383dfbbaf2"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf8ad3294210b1983e59211b7f0c13d74b21c5ac860de74baace75c433a81efb" => :catalina
    sha256 "d4c8cb15ab54e31965093a1de8b8cf8a5a2699052e35e17089df0a871ad19c10" => :mojave
    sha256 "ce2f2ed412dbe3dda7cf57989458f22e07360be622767a578341bf579485be06" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    path = testpath/"ansi.txt"
    path.write "f\x1b[31moo"

    assert_equal "foo", shell_output("#{bin}/ansifilter #{path}").strip
  end
end
