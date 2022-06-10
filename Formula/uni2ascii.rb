class Uni2ascii < Formula
  desc "Bi-directional conversion between UTF-8 and various ASCII flavors"
  # homepage/url: "the website you are looking for is suspended"
  # Switched to Debian mirrors June 2015.
  homepage "https://billposer.org/Software/uni2ascii.html"
  url "https://deb.debian.org/debian/pool/main/u/uni2ascii/uni2ascii_4.18.orig.tar.gz"
  sha256 "9e24bb6eb2ced0a2945e2dabed5e20c419229a8bf9281c3127fa5993bfa5930e"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/uni2ascii"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "41fe846185b9973e4e70656c6b1bed7f65ab9dcd281e147ea9098978c1de07af"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    ENV["MKDIRPROG"]="mkdir -p"
    system "make", "install"
  end

  test do
    # uni2ascii
    assert_equal "0x00E9", pipe_output("#{bin}/uni2ascii -q", "é")

    # ascii2uni
    assert_equal "e\n", pipe_output("#{bin}/ascii2uni -q", "0x65")
  end
end
