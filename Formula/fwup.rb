class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.5.2/fwup-1.5.2.tar.gz"
  sha256 "d82ce3c70335170bd8f1ebe10940585c8a797521a8c35ad85aa34a52e8d4341e"

  bottle do
    cellar :any
    sha256 "50db5027a01052fe99c68b743b737d4af494ba49eacab761eacd07f633f5754d" => :catalina
    sha256 "d5c8f9f47df5e71a514ee41451be9d1e21d2876cbc4999f93494df17332f143d" => :mojave
    sha256 "735404024192dd4d66c1754e1d3a814377de444cfcf480bb1ebf6f56318ae6fa" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
