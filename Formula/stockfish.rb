class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_12.tar.gz"
  sha256 "d1ec11d1cb8dfc5b33bcd6ec89ed0bafb3951cc1690851448a2696caa2022899"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f6bcd62e239cdd9779771367e32137045772d90b6ab3dae858a85bfbe104a95e" => :catalina
    sha256 "f6bcd62e239cdd9779771367e32137045772d90b6ab3dae858a85bfbe104a95e" => :mojave
    sha256 "5debb14a1764281072d0ad4c350a1ce4014904a9956dfa5046347965486573c2" => :high_sierra
  end

  def install
    arch = if MacOS.version.requires_popcnt?
      "x86-64-modern"
    else
      "x86-64"
    end

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end
