class Icecast < Formula
  desc "Streaming MP3 audio server"
  homepage "https://icecast.org/"
  url "https://downloads.xiph.org/releases/icecast/icecast-2.4.4.tar.gz"
  sha256 "49b5979f9f614140b6a38046154203ee28218d8fc549888596a683ad604e4d44"

  bottle do
    cellar :any
    sha256 "dc5502c9e311f630c2c1cee345d5812337bb5cd0a069250cd959853c16a387f5" => :catalina
    sha256 "c7e0961945d1f92f464b9970a5bd65a2561f73fa4043811cd2d3294bd6bc7c6d" => :mojave
    sha256 "331a9f503776b42f3ffc5dde709b1a0500bfd05d3af2f5b79880832a683a8413" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "openssl@1.1"
  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make", "install"

    (var/"log/icecast").mkpath
    touch var/"log/icecast/access.log"
    touch var/"log/icecast/error.log"
  end

  test do
    pid = fork do
      exec "icecast", "-c", prefix/"etc/icecast.xml", "2>", "/dev/null"
    end
    sleep 3

    begin
      assert_match "icestats", shell_output("curl localhost:8000/status-json.xsl")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
