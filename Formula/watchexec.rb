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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e45dc5b0aadc70d3b7bf25694e9b3ebb71a5e716bc8a7630399309d79d40499"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ee592242d942d322b0e0322f8968824e5cef982939e7a350b25f2da45149516"
    sha256 cellar: :any_skip_relocation, monterey:       "5ab6feec4b2f369d2385c2a001ad23a439c88e970340b4b61e1c97e23cedebce"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a537f40d4b272d41ba9aeb50341b3ebae0854d5d4b2d0f027bf85782324c50a"
    sha256 cellar: :any_skip_relocation, catalina:       "a87177fe3a23d57c1133d4ccabc7aeb301bff20fb4478b3a2e0e8544b68f521b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a717c4019c0facd92fd212eecdaab70ab5d2a3193b062caced7f6760657cfa8"
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
