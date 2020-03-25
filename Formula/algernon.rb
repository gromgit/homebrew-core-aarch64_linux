class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.12.7.tar.gz"
  sha256 "1e04be1274b875a90f3ca1b5685f0e2c2df79ae3b798a1c56395d0b5b5b686b3"
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ba1670ae654b3d9d09ce08b8df8a0ffe0e86c851525c02c4c967597586c5a2c" => :catalina
    sha256 "d1243c6079bd0d55bc2d2444d03aeb5a32cbdb0b05a9f6324fdbd6ce4622a84c" => :mojave
    sha256 "31f05cef895112f71f7dd0665761f0e8006ef5cc75f3f3658e1456471ba1550a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-mod=vendor", "-o", bin/"algernon"

    bin.install "desktop/mdview"
    prefix.install_metafiles
  end

  test do
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":45678"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:45678")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
