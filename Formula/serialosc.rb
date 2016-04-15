class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "http://docs.monome.org/doku.php?id=app:serialosc"
  url "https://github.com/monome/serialosc/archive/1.2.tar.gz"
  sha256 "9b4852b8ea402f2675b39bec98ec976fdd718f3295713743e3e898349e0f1b77"

  head "https://github.com/monome/serialosc.git"

  bottle do
    cellar :any
    sha256 "b2b9ec1d9e3058d7752eed3773f7fa724981ddbae5a990db10ad3e98f02d1c1f" => :el_capitan
    sha256 "a601c8dcadb93c4e4ee0f15e7db22dc0e124bcaf9a3e7b875091d612ea70b078" => :yosemite
    sha256 "e08f42f4285870af8ba9f341cda5e4420c7535a55f54c9fb78582cfd53fdad3a" => :mavericks
  end

  depends_on "liblo"
  depends_on "confuse"
  depends_on "libmonome"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf build"
    system "./waf install"
  end
end
