class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.17.4.tar.gz"
  sha256 "d01fe0157094f6793eb6eb8b70fca4731857ca6a3442224f0f4cc1f69bf0ca04"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25cdad9f211d18008744b15e6eb348f93c7555146aceafb47a6f92603d21f2a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76dee1acec63b8133c48abe8a667ab389a1d6432225d0f2c0222fbab30287a4b"
    sha256 cellar: :any_skip_relocation, monterey:       "3a57dff3e7fbe10e9b182d5aace715de2c90a1e1c36b4dc66806b9c989047d2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f371c4ebf2bf4419c7c8afe7caa9603ab99e3d5760e98e816eb88ef1d6b0df8e"
    sha256 cellar: :any_skip_relocation, catalina:       "87e02d9d31751f6a6fb399f007d4e8eb35507b05ce8b6bdcf0c5dcd3a00120cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a59d74bbf28f1cf99baa2e1538a8398bbd3d2ffdce793566efab6ffa7dcae0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end
