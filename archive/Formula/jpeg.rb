class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v9e.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v9e.tar.gz"
  sha256 "4077d6a6a75aeb01884f708919d25934c93305e49f7e3f36db9129320e6f4f3d"
  license "IJG"

  livecheck do
    url "https://www.ijg.org/files/"
    regex(/href=.*?jpegsrc[._-]v?(\d+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jpeg"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "706718beb5b8dd97c0fcbc9dbde6ae487f3c0953c37acd557657f727834224f5"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
