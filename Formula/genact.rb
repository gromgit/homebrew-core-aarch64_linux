class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/v0.8.0.tar.gz"
  sha256 "cb7e8faf9c81a9c39ab9bfd5e6f31d36ff0e080b4acab6ad483954195ec802ea"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "550cbb0ca15284dd7b6bbf4e006b80972a2ba3e1aadff66624b1bcbce9f70f39" => :catalina
    sha256 "403a5768a7198c6d317a8170e9eca2937ca3e956c418b041840f2f30f811ffc0" => :mojave
    sha256 "0f53228b7e1bc47bab7b596067b67e3670649749a5192d3435e6381069d6d1bd" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /Available modules:/, shell_output("#{bin}/genact --list-modules")
  end
end
