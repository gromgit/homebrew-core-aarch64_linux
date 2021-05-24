class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.11.1.tar.gz"
  sha256 "b2f004a885d96ca5c8a284dbb3efa77b81de4ba0b08a5a1d63f36d3161651ec4"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "083437e9ddb8743fc5b30125e3a8cf3c96df308e2da38d643c50038999d30be0"
    sha256 cellar: :any_skip_relocation, big_sur:       "09ce7f44f1e1389361f858d088c8f7da3a1eab7eb5305e47947acea2cc40e86d"
    sha256 cellar: :any_skip_relocation, catalina:      "c6fb62bddce85a5d647d4da666f3c961943fc879402ac684bc2531e09a50d58c"
    sha256 cellar: :any_skip_relocation, mojave:        "2c45a418924fd06cf7087fcf6864f54a1a4a3c1cad1e948e9155bff85072c87b"
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
