class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.12.11.tar.gz"
  sha256 "0ecedfe86cf2016d8da281ca64d76b9383f76b0d58acee0d80e08c61df5035cc"
  license "MIT"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "125ca6ca368cd6e9d92cdca03f4d5e1fa0f606c04024a043f4b530dc5350982a" => :big_sur
    sha256 "1f227a42c3708e7ba3f22a69c88d360d10bfc9f82bee7d0a8d2548a49b815ab1" => :catalina
    sha256 "40130b27669fc8c7d2b842818096ff1a6db34442cb9f88e06137c45dc8733d06" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-mod=vendor", "-o", bin/"algernon"

    bin.install "desktop/mdview"
    prefix.install_metafiles
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
