class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.8.1.tar.gz"
  sha256 "41662bb14ae89b9f25c2a956571a2855f977273261228f1ceba856fc8b7f2eca"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b65ffb67327e5e7e813ab5eed6261d773a21b536d5c619173d182872b111bb35" => :catalina
    sha256 "34c167ebe15dc8d0060ab0ec199a769641de5879cfaf447103384d02ed34b166" => :mojave
    sha256 "b760459ed6697f9bc1be81004f06a921b094c525ebc21c4d9abaf0019111b4ea" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "libiconv"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "clone", "https://github.com/extrawurst/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
    sleep 1
    # select log tab
    input.puts "2"
    sleep 1
    # inspect commit (right arrow key)
    input.puts "\e[C"
    sleep 1
    input.close

    screenlog = (testpath/"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      :invalid => :replace,
      :undef   => :replace,
      :replace => "")
    screenlog.gsub! /\e\[([;\d]+)?m/, ""
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "SHA: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
