class Gif2png < Formula
  desc "Convert GIFs to PNGs"
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-2.5.13.tar.gz"
  sha256 "997275b20338e6cfe3bd4adb084f82627c34c856bc1d67c915c397cf55146924"

  livecheck do
    url :homepage
    regex(/href=.*?gif2png[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gif2png"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5dfcf77ec792a2936cfd80c00eda9f442dee13545ddbd5c204b4387c87651208"
  end

  depends_on "libpng"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end
