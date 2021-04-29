class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.5.9.tar.gz"
  sha256 "03a628339fc8753b2d63533eca8749c0392f09063101c6d3317482500c5860ab"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "53d42e8e7a5ffcad1dc128c13a298ca5d67dc886d7d8f0932d3fb97ffb6983f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "764f00a56b1ce5980841e0bebf383d9dc74b9c88ad57815466f5aef55de17046"
    sha256 cellar: :any_skip_relocation, catalina:      "9c3d03d07a386f4f9dfd4b2cc6f6652cc929eaeea985d89a56c0053d014c3b52"
    sha256 cellar: :any_skip_relocation, mojave:        "4464e523b0aa7f2ef420b720943bc90b01ffc8ef5516761dcad677f53cfc6eb5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts "#{bin}/xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end
