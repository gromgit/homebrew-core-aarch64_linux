class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.5.3.tar.gz"
  sha256 "f8401257e1cae721019da05a11dd00c2f114121ccd525452b783d472da59b6e8"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  livecheck do
    url :head
    regex(/v([\d.]+)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0f66a74fbd7def9b4bf0bdb77f2179caa0b61b18ad22cd401e4ff85c5a7d6bb4" => :catalina
    sha256 "eefa1e6de716f8b880dc1ef6bb137a5169bcfc3a4b1ba41a7f54b20904cbaf27" => :mojave
    sha256 "98ae783e45795c50a21d2dbbaef947bd000b194a2039f4a31cb309964b44bfb8" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
