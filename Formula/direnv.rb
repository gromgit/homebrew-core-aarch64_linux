class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.22.1.tar.gz"
  sha256 "b902f30deadd332b8553ca0f34aacf6daf62bd104b5d57ecc9bee2fdcd70d1c7"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44e70a14fb3eff7708df0c7aa46701b4476568cf2b7fd06f68ced2dd0a4c52f7" => :catalina
    sha256 "3214ef11c015566e5d4891242659d89705dc45ee84c76493280d88264cc2cff8" => :mojave
    sha256 "7463876a5196f01d219cdadd5d57ee4f035e0d4c37dbf9d18bc8d99738c05160" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
