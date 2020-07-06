class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.3.3.tar.gz"
  sha256 "062145687d4c33f66b35be15633ff60cd24fd467bf2791f1a8c3ffb069935aa4"
  license "GPL-3.0"

  depends_on "go" => :build

  def install
    system "make", "release"
    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less")
    assert_match "Hello from \e[01;31m\e[KHomebrew\e[m\e[K!\n", output
  end
end
