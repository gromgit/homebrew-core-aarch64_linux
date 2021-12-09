class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.19.0.tar.gz"
  sha256 "bcbffb592a5ae49658c79ac7b0daefe4bac3d2b988fdbaf0e868b8c308962f0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6b29e8ce3b401925d50e88a94e1502c101c58696cf537a98491644a06ac649"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e31ec12f9a8d5871afb3e6bfb3cb267655a67bbd681105f9a410c7d9e6ec308f"
    sha256 cellar: :any_skip_relocation, monterey:       "b8a8361407e7eb798a49fa526904e71f27bf33a3175ab11913b57ab5acb1971b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8624b345defed568ad4e2e577c847a57023e4390025b80eb01e9f1458e0957ce"
    sha256 cellar: :any_skip_relocation, catalina:       "dc198bc80551c09d92b7276790d6a3df061f5e09b5274a632f1855012bc6a8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10f3bb63255f5084066367f892848e0df6d44237aa65c0f2c231dee7954af2d"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 1
    input.puts "\e[C"
    sleep 1
    input.close

    screenlog = (testpath/"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
