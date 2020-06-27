class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.12.8.tar.gz"
  sha256 "562d6f1145980d5e4c8eaefc2780801b163d228720599f22165135182018d6bf"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9f58bb11a8790a99e8fc93cf70e772cc97bae24f5ec86e9811f43be34b563258" => :catalina
    sha256 "1da54e8872f2d5e98524c1d546e9c409dc5b8b705c6e2752ac8658dc8d8a3d07" => :mojave
    sha256 "956560cc8c147107a176d827e8ddb48637be59b9318d906c3bfcc33fc0020d20" => :high_sierra
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
