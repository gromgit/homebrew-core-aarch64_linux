class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.19.0.tar.gz"
  sha256 "6837dff4d14802e1e3714a2f3ef4330f8faadd10449508b128cff7f93d921101"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e08386dc30bf232d3cbf60033b0c3295a1817ea9846c847b81e9cefb49bdc689"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cbdcc82ed43c6be9108121e9d9d81ffca2af0a874647a1f107c482b0fbef98f"
    sha256 cellar: :any_skip_relocation, monterey:       "78a32be881cef4939b76872c02e71872cacf68a995d8c840496849e91fe973bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1bcd600f3d3346c84ba7336259b9c6dd3ecfa17008de39a5847e7d8bdfb7de4"
    sha256 cellar: :any_skip_relocation, catalina:       "4506ae1b77665e3b8a17311df6479e16275098f0f77600afdc54bee8ae994617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43c15a90807e074465986335697bb559bbad24d10bc6dca0c54703bf3ae95b6f"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end
