class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.4.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.4.tar.gz"
  sha256 "bfc6255ead837e6966f092757a697c3191c93fa58323ce07859a5f666d52d684"

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "03ab59527335488e08f4d77527efa444e7e732d7aa8c2e4c852fe1d829d10146" => :catalina
    sha256 "c4ca091169b76af62be799ebc0d56ccb621ebc1cb8b790e31867ab0b0fd21e45" => :mojave
    sha256 "56cba35b06fd322068776ac49afc3f040fcba5defe28fdbe937cae7e1d01c1e7" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("#{bin}/oathtool 00").chomp
  end
end
