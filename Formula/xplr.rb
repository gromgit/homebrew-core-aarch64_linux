class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.11.1.tar.gz"
  sha256 "b2f004a885d96ca5c8a284dbb3efa77b81de4ba0b08a5a1d63f36d3161651ec4"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "508f4f8b3b36aac0ac2d6843aa3d41fe4abe418837fa1f872e27616a45661dab"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd4a3981c9cf6ff4a3fa8178b801aa366ae3594a0e181da7b976d375de91a447"
    sha256 cellar: :any_skip_relocation, catalina:      "7eb4ef8456f9d61cabed1e7600ed87ad40333bfca0035fcc0e63f2544e6ffa78"
    sha256 cellar: :any_skip_relocation, mojave:        "35f493279288ba79fbf2547d1a0bf9615114f7e7a81a39b2451c81f31a07f636"
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
