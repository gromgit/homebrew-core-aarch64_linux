class Ccd2iso < Formula
  desc "Convert CloneCD images to ISO images"
  homepage "https://ccd2iso.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ccd2iso/ccd2iso/ccd2iso-0.3/ccd2iso-0.3.tar.gz"
  sha256 "f874b8fe26112db2cdb016d54a9f69cf286387fbd0c8a55882225f78e20700fc"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ccd2iso"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "afa771b300e69133797f92eab1015f3eeca6fb7161c30b74c6912e12e0109d79"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(
      /^#{Regexp.escape(version)}$/, shell_output("#{bin}/ccd2iso --version")
    )
  end
end
