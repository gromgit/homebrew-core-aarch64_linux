class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "https://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.5.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.5.tar.gz"
  sha256 "d207120c7e7fdd540142d04ca06d83fb3277c8f2fb794a74535d04b2aa0ec219"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://download.savannah.gnu.org/releases/oath-toolkit/"
    regex(/href=.*?oath-toolkit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "461150aa963067a32286e1e9dc433abc8979ded568406763de8143066c5f2031" => :big_sur
    sha256 "c2bcad1082c8c069fdc3ee33a667f55498dd87fed6ae73ad8dec8bffcaf342ff" => :arm64_big_sur
    sha256 "ba7b1965a0a32616bcc13f6475aaa97c3a16de6bbcc2779b8f88cdf801ce4465" => :catalina
    sha256 "dbae2b106ca1338f2e610d5121e9b318135f1608302cad122ba6912a34f03b6a" => :mojave
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
