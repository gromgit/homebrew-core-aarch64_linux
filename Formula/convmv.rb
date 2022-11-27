class Convmv < Formula
  desc "Filename encoding conversion tool"
  homepage "https://www.j3e.de/linux/convmv/"
  url "https://www.j3e.de/linux/convmv/convmv-2.05.tar.gz"
  sha256 "53b6ac8ae4f9beaee5bc5628f6a5382bfd14f42a5bed3d881b829d7b52d81ca6"

  livecheck do
    url :homepage
    regex(/href=.*?convmv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/convmv"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "466e942ba9932579cb42d5b0ebc978be7df823fae5a1307565e78871cd10d93c"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/convmv", "--list"
  end
end
