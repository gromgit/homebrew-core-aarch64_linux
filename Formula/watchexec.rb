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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90d1caa558c7400947053b27c2b701ad61b9011315a7117b4ed57097b279c100"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fa9b3558e762ffb8051096309cb312fe6d67f9c6cf8d5aaf4a895ee5a16a6c9"
    sha256 cellar: :any_skip_relocation, monterey:       "4d48b42ccd2bd032a9ad36773bd6479620bbc897972188245e86bb2491bc945e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1d266bfb5b61d679a642e75bc170e9b02a5a33b7fceab6223cf307a3e4be4fb"
    sha256 cellar: :any_skip_relocation, catalina:       "ee3999abbfaa53ec422a29d84eed5207c18e5d816fabad1f097412d336cd6811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a1935deeb267e540e3d45d7adfac9b4de0a576ad81e1b65f132339ce85a170"
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
