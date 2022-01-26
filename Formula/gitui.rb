class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.20.1.tar.gz"
  sha256 "eccec120dfd4c5c33a74d331a53f3d0c6cb7200e26b0c4c7873278eb951bc379"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ece4f1a613bc88b05a3b00e88f0623617c19befd3e3cec5de934cc5e49fdd4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c98fc4b91b6e326f529be870428721e2f21060d466db73f7f1d809888924928b"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab951d31a956c3f5c2d716db769819a2fe9628e4a7fb9cbcaf96ad2cb3c37fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "442e39bf1e63fdf6c0c2282b4907a6fe571d86789f7673ed575730c6369f88dd"
    sha256 cellar: :any_skip_relocation, catalina:       "fb7126d4ab88082a8c8b34818ddabbff25dc16be98d13b004295f444748a359d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae322f86d610a28a3214cb6583d5d19db4dcefba59919238d9b91f61ec318a1"
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
