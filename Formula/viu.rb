class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://github.com/atanunq/viu/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "ee049c065945a528699799f18de4d82355d5b2f5509d2435b9f5332c8dd520c5"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e[0m\e[38;5;202m\e[48;5;202m▄\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end
