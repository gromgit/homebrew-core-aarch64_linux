class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.33.1.tar.gz"
  sha256 "90e1f2e795cd0e694d7a514faeee19f881c35ec46811298adde692d606837d5d"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fcf639cd449b211179f102b54e8f60293c1efaa9222a42e6a544f82e2929d61" => :catalina
    sha256 "2b59dcbc3bdb37652f8d49bb648a8970c995bd4493979e3763619dbbe67d51ca" => :mojave
    sha256 "0a650fb57fd0dbe002d11cba09d5ae254d6f3d78695ded147142a59a3d086b33" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
