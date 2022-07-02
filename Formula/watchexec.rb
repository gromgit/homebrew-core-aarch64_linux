class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.20.4.tar.gz"
  sha256 "170d9ab9cd3661ca024ca15e341013b7adb56a87bbf486ce0dc34e092f2547a2"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3088b949f8c235736188d3c44bb9016417eeba4c0026f599ba1ffc70d0e2f742"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b06f7bdb41303017811ea1c4cf4e2e6e1d9fa68480caa325745bc065e8c2e4b"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2a6fe90509420804fb2bb7af1a7bfb06427ecfd6d43d7aa13f2a97e9d487f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d392740b6ac5b37bffe53e4c75072accf7328b95c65dc7955057eea5d23a29b5"
    sha256 cellar: :any_skip_relocation, catalina:       "38b8e287f32ffe71e1ed4692efddbfb2be0f16067d44651b4df69e9ad7292e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d2cdaf3094317fe3b4a6f5c63d77520adcc92af5727c193a172a9c9560481e"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
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
