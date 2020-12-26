class Vitetris < Formula
  desc "Terminal-based Tetris clone"
  homepage "https://www.victornils.net/tetris/"
  url "https://github.com/vicgeralds/vitetris/archive/v0.59.1.tar.gz"
  sha256 "699443df03c8d4bf2051838c1015da72039bbbdd0ab0eede891c59c840bdf58d"
  license "BSD-2-Clause"
  head "https://github.com/vicgeralds/vitetris.git", branch: "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "a71a46511c0544c0d43f488710bfe420e3a45e629dd1f29692d02d88f4b0392a" => :big_sur
    sha256 "802182254bcd3d143d7499b9ed0df276958aac04af0728dafa1f337a2789fb45" => :arm64_big_sur
    sha256 "618e1eb2f8e9d70d3e7f6593ae58615f8d2217faa512af717d52b62cb4d5bc26" => :catalina
    sha256 "316f0e559e519a2a44e6e3fff6298cd138f7df3e62372a07f6b03fd7d5bf650e" => :mojave
  end

  def install
    # remove a 'strip' option not supported on OS X and root options for
    # 'install'
    inreplace "Makefile", "-strip --strip-all $(PROGNAME)", "-strip $(PROGNAME)"

    system "./configure", "--prefix=#{prefix}", "--without-xlib"
    system "make", "install"
  end

  test do
    system "#{bin}/tetris", "-hiscore"
  end
end
