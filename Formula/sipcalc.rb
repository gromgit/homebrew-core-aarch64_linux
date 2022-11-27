class Sipcalc < Formula
  desc "Advanced console-based IP subnet calculator"
  homepage "https://www.routemeister.net/projects/sipcalc/"
  url "https://www.routemeister.net/projects/sipcalc/files/sipcalc-1.1.6.tar.gz"
  sha256 "cfd476c667f7a119e49eb5fe8adcfb9d2339bc2e0d4d01a1d64b7c229be56357"

  livecheck do
    url "https://www.routemeister.net/projects/sipcalc/download.html"
    regex(/href=.*?sipcalc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sipcalc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "179b3fa4af79a10957f89971f47d5c50211e40784948ec2df74189f925ed6383"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipcalc", "-h"
  end
end
