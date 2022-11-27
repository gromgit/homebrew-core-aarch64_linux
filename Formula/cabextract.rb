class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.9.1.tar.gz"
  sha256 "afc253673c8ef316b4d5c29cc4aa8445844bee14afffbe092ee9469405851ca7"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?cabextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cabextract"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "28d079446b8dd5f4419fc3db282b3b384c2cb38014d780b1f2d940cbf68ea103"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # probably the smallest valid .cab file
    cab = <<~EOS.gsub(/\s+/, "")
      4d5343460000000046000000000000002c000000000000000301010001000000d20400003
      e00000001000000000000000000000000003246899d200061000000000000000000
    EOS
    (testpath/"test.cab").binwrite [cab].pack("H*")

    system "#{bin}/cabextract", "test.cab"
    assert_predicate testpath/"a", :exist?
  end
end
