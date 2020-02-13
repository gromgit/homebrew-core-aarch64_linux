class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.36.0.tar.gz"
  sha256 "fffc89dd93672408d4b4f44c487fe304ed0f54fdc508f41b1434ab7b35ee3de6"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bb6f827c6f789e27f80ab3c01c22eeb4cf499cb463631d046afbe6650e5b46a" => :catalina
    sha256 "42abe5b068bc465f04762b751d6462f83da06cdecfcbc6c985b88757148ace55" => :mojave
    sha256 "624e74405148da356aa26439b73b46df5e34562fdc7989fe19fec8c12675d2ee" => :high_sierra
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
