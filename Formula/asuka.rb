class Asuka < Formula
  desc "Gemini Project client written in Rust with NCurses"
  homepage "https://sr.ht/~julienxx/Asuka/"
  url "https://git.sr.ht/~julienxx/asuka/archive/0.8.5.tar.gz"
  sha256 "f7be2925cfc7ee6dcdfa4c30b9d4f6963f729c1b3f526ac242c7e1794bb190b1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3345610cad8edfbe09efc8c8bc833f5c63a2fdf17379560d16e35b804540cab1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34f14fd0c765961b025d4bbf08f942f5227e92ff512c0373fd34b0115081663e"
    sha256 cellar: :any_skip_relocation, monterey:       "9489a13bb3be9f29e279bf1e9e8ffe7aa03027dd6b49e6cd77b813baaf4e4f82"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dd678d604b4d5d7399241358da21ff09a4de36ce581940091ebf9d3780645ed"
    sha256 cellar: :any_skip_relocation, catalina:       "599be4ef5fbde219bb6740b4f687ec441b2dd1723135bb2aff60347c0522bd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8426e3f5c6cda8c46638bc53d10ae0419cd37227d928bd0a8fe853a0a2ef4984"
  end

  depends_on "rust" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, _, wait_thr = Open3.popen2 "script -q screenlog.txt"
    input.puts "stty rows 80 cols 43"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/asuka"
    sleep 1
    input.putc "g"
    sleep 1
    input.puts "gemini://gemini.circumlunar.space"
    sleep 10
    input.putc "q"
    input.puts "exit"

    screenlog = (testpath/"screenlog.txt").read
    assert_match "# Project Gemini", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
