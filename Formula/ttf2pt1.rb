class Ttf2pt1 < Formula
  desc "True Type Font to Postscript Type 1 converter"
  homepage "https://ttf2pt1.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ttf2pt1/ttf2pt1/3.4.4/ttf2pt1-3.4.4.tgz"
  sha256 "ae926288be910073883b5c8a3b8fc168fde52b91199fdf13e92d72328945e1d0"

  livecheck do
    url :stable
    regex(%r{url=.*?/ttf2pt1[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ttf2pt1"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fe5ec99673fe482748b747eba39cad097e88a27c95d74a582ae45dac2ce802e1"
  end

  def install
    system "make", "all", "INSTDIR=#{prefix}"
    bin.install "ttf2pt1"
    man1.install "ttf2pt1.1"
  end
end
