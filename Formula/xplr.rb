class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.0.tar.gz"
  sha256 "63d6f85880a8877ef38d4e77aec5ae74e40f96208a12f9d08e43ab19527dac36"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "750be9ef323b1083a628598881b7f828d0d1e8f88718afbf37ef42bfa9a0d667"
    sha256 cellar: :any_skip_relocation, big_sur:       "8421236245c179a7a1042f49240f371029ac40eadfec4665162c5b5582d951d3"
    sha256 cellar: :any_skip_relocation, catalina:      "f8ffeb93dd72599ba07e2c2954209272d13e0a588af4dd539a3bbfbbf3a66448"
    sha256 cellar: :any_skip_relocation, mojave:        "60eb0c0e6c21d5ca3e8c4024765ea224b175a3ba564615d49a345dd0fc3439f4"
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
