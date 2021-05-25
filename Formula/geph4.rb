class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.2.tar.gz"
  sha256 "1294c45c642dcbc4e913549cdf12168ab5df504e83b2b9fd887e99c22609e7b7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02fd995c7ea923e57a6cb38e98e17edde83c0ddd69b43fb4162785e6a60b9550"
    sha256 cellar: :any_skip_relocation, big_sur:       "1dd11d5679414da046e44cae9db03f58a3e79b8e86bd593245da746ca5081a1c"
    sha256 cellar: :any_skip_relocation, catalina:      "8038773c1d0bdc37993798d1e4b281ddf40610e68a7b810f946bf08b7de1a68b"
    sha256 cellar: :any_skip_relocation, mojave:        "9d4d62ece3463d0de12a3de0223044a3b409732b6e5ec833e4d55e7a8b2b6049"
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
