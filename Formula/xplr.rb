class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.5.13.tar.gz"
  sha256 "cc705c0f3eedf88ec8c22adb4d8629e66a8bf5ad55ccb4e24a1d6d4a7de6d29f"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efc4e8379a39b7743b5ce02c60291c3fe5d7729304dddc5629afb0951ea51832"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa38e0a94d6e12dac7216d509adfeb811aeabdf2129c8ae7b7f304021d874bf2"
    sha256 cellar: :any_skip_relocation, catalina:      "7667e5718bc358d16923535017927791ed21a408b4784db3ec58a6a4fa77ac20"
    sha256 cellar: :any_skip_relocation, mojave:        "309933ea1629c04a940854ebeec22c17ecbe2135ee28aec7f08f1227c2e926bd"
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
