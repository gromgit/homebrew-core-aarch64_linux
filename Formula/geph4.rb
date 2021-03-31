class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.3.0.tar.gz"
  sha256 "2158e562a39f0e6deecf0cf4a60f17314d99cc7e185c3803ddc219c3c5d66adf"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7181a6d681853cfe2cb7c5ff6c5b58ba09e3e6f78d4a252c92b19235d2f806e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "cbbbde7f65f9831770efc27a6df52858161f153d7b573907528c64ac1869a5f2"
    sha256 cellar: :any_skip_relocation, catalina:      "2d94528b27cad3224619e8f183b281f2c73e30d4e341f72e0086142d7c4e3650"
    sha256 cellar: :any_skip_relocation, mojave:        "79f1af5104be3ffa186389861a161a248e88c24ad6c6b9a849dfbc375323fde1"
  end

  depends_on "rust" => :build

  def install
    File.delete("Cross.toml")
    remove_dir(".cargo")
    Dir.chdir "geph4-client"
    system "cargo", "install", "--bin", "geph4-client", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end
