class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/1.12.14.tar.gz"
  sha256 "cab5b01923142e0326ea2a01797814bb2e8ea9f7c6c41a3ea0ae7df3b667e86e"
  license "MIT"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/algernon"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c7f77e9d279b0d4859f08c97506baee7b75a0b2a447231b001837ef59c790072"
  end

  # Go 1.18 can be used after the next release (1.12.15 or later).
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args, "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
