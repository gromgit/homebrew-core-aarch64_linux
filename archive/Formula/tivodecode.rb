class Tivodecode < Formula
  desc "Convert .tivo to .mpeg"
  homepage "https://tivodecode.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tivodecode/tivodecode/0.2pre4/tivodecode-0.2pre4.tar.gz"
  sha256 "788839cc4ad66f5b20792e166514411705e8564f9f050584c54c3f1f452e9cdf"

  livecheck do
    url :stable
    regex(%r{url=.*?/tivodecode[._-]v?(\d+(?:\.\d+)+(?:pre\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tivodecode"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fd21e749717040ac54ac1e5f87080af2dd2786920a4b85e30c5c9548b2d4ba73"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
