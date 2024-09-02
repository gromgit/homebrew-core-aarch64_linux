class Mp3gain < Formula
  desc "Lossless mp3 normalizer with statistical analysis"
  homepage "https://mp3gain.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3gain/mp3gain/1.6.2/mp3gain-1_6_2-src.zip"
  version "1.6.2"
  sha256 "5cc04732ef32850d5878b28fbd8b85798d979a025990654aceeaa379bcc9596d"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mp3gain"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d50f456bdb999e2653b58462b2ed940c7178e88aec8c50c189df952d37f36d0d"
  end

  depends_on "mpg123"

  def install
    system "make"
    bin.install "mp3gain"
  end

  test do
    system "#{bin}/mp3gain", "-v"
  end
end
