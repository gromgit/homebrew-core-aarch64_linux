class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.14.4.tar.gz"
  sha256 "c007d462661619257622283db1c91055e57673b9792947d079cd1286a2371b95"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a017d0e7704de1a232c2676fb7d93893a663bb79853329b11ef884523c4f60d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d14dfe6349aba4ff0ee474ee1eef4e24afdf72b5d41aecd5b19e18eecc3589f"
    sha256 cellar: :any_skip_relocation, catalina:      "34df8b7726d5521685d528619c6f9bbd97adf0e03aae13d6beb42888b91c703b"
    sha256 cellar: :any_skip_relocation, mojave:        "092e1a366df36aaed426a0b78fcca30880b785d2f2038840f906c169d93b06c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed8df350f492bf81cb84eb3dee1870da3db46f9b9b83204acdefe17eeb9c177"
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
