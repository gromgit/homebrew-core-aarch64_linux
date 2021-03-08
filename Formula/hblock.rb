class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.2.1.tar.gz"
  sha256 "d24d3791cba605070e0ea30aa32d4e567104562a8f1cd909865959df7a10bb70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "07cf3cb10349f9afbd7adb36ae2f4c7e3444ec9fc4c6bcfb5cd65c77488eaabd"
    sha256 cellar: :any_skip_relocation, big_sur:       "8752ac1c6b5d9a16197c952cab95d0ed0f7259db9f98738471b679434ea533e6"
    sha256 cellar: :any_skip_relocation, catalina:      "4599d523e51403bc471db40003a8c340d261acda6ed2b5eb26f92d5800aeec68"
    sha256 cellar: :any_skip_relocation, mojave:        "1a04f7ac7b843758d8fd74b9885f6bd608c28fffd2c127904515922720c6b360"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
