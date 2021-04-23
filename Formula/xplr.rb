class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.5.6.tar.gz"
  sha256 "0c53400d5e712d91138e1496892c1539d57998165c415fb6084304229debe639"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a6f32ab5012b8ef7461660d94fb86abeca2c4017b2567dad9bfadf7f06cbe97a"
    sha256 cellar: :any_skip_relocation, big_sur:       "8840395de760a920626d55e5a30dd2713446a9fe7785175af067f806adb80168"
    sha256 cellar: :any_skip_relocation, catalina:      "1a92e84dcbfaf9fbb5d83821d1212e68b7a7eb33d75274288ce87f9804271ac1"
    sha256 cellar: :any_skip_relocation, mojave:        "cc01ef96e3cc3fc849c0eda7b00fa150eb585d427dd17200bba1e38668c78e45"
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
