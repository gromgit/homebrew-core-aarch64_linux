class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.4.1.tar.gz"
  sha256 "2a713a00aef8db3de98fe5a936e84fdf7fcebfa8211aee03a4c7754aa094d7d1"
  license "MIT"
  head "https://github.com/hatoo/oha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7b963f20db682935f4c2b0f8a736c0b29058aacd17c09a01482103a8c6b026b" => :catalina
    sha256 "2f04543a04d5b3cb14340adc14a5f087f2ca0ae171248e7f650fa763feb4a83a" => :mojave
    sha256 "aa2f9c7961b84e7b68046ca96f3ef0be89c25b3521275cc7a8bce10282a35213" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
