class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.10.1.tar.gz"
  sha256 "2d6fa87d88002716cf0fedef9d4332b7212ee05fbfa4b8c536ae4270bef99bce"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3be65a8a965a8cb4643641c63119afc27221e1dae3e227e2ee49b4943c55ef75" => :catalina
    sha256 "a9d7d94a1a6de1e61c526b828d63a60b6526b0bd93942d69bc4f86ddfb07034a" => :mojave
    sha256 "d9763fde6296904449114c083f8f79728da805418443aad002647157f6fb70a2" => :high_sierra
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
    screenlog.gsub! /\e\[([;\d]+)?m/, ""
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
