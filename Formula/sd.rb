class Sd < Formula
  desc "Intuitive find & replace CLI"
  homepage "https://github.com/chmln/sd"
  url "https://github.com/chmln/sd/archive/v0.7.2.tar.gz"
  sha256 "8efd38c7641f94f0cf83f04ac4e6033c1794b93dbfdaca893c3403801afe7cc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "90e4cc0f26054b4a9fff70e7581c1401691d76c87ed194ea0d4aecd6e631dfa0" => :catalina
    sha256 "bd7c2b8037e9d7e39cb1a96efc9b0a262ad1f5c98b7a32a1c025e288d4db14fc" => :mojave
    sha256 "9c2ba1245e92f6e43daee31739dbcf3451ef75eac2026e4f7017d7cf1d9f784b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "after", pipe_output("#{bin}/sd before after", "before")
  end
end
