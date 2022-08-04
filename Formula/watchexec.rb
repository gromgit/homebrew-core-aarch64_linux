class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.20.5.tar.gz"
  sha256 "2bc04c7ecf58d34a48c3eeea54a76b7e621717cb93305497bea2f6399dd119c6"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ead924f6614bde30ec7a1a9a9e4eadb121791681f0a9f227a5523f2caf4f0cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64de9842574f1d8fe3c32e259caccf90f68623142e4446436609bce2fef50de9"
    sha256 cellar: :any_skip_relocation, monterey:       "ce03eeffd0cd2d9a581b6b734f2312621fff73424a9889a8a1ea445cf0bcc70f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f0ce1fb90239b7aba8828889837b8c82dd2252605767a2edc9faf86d872754f"
    sha256 cellar: :any_skip_relocation, catalina:       "023b6cadf43434f17bcbf475f2fea18de9d0630612e2bfc9a9394b546d961194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525f05db4694fd23d4b68ef6c8f3d9f245ea217af6ed448ed0060818c7f5bdbe"
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
