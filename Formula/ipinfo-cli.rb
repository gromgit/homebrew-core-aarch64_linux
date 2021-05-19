class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-1.1.4.tar.gz"
  sha256 "fa1b055dd4cca4a5a57374d9cc1250eadba2f17871d38b5b71914b379a9e84ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e014dfe037ebe7b58b7bbc86087857805a39e707c22524f2ac583da117f2b736"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae2d6af663d2d54f85b54e601f776475023d975db1120072eaecc6f86e9869ec"
    sha256 cellar: :any_skip_relocation, catalina:      "000ea11eb227bf54236f17bf552badc519b6187289a3ac50699088e71c8dbb95"
    sha256 cellar: :any_skip_relocation, mojave:        "f431b9cc62ac3ad893195d0934c58fc75e3e386d82774778c87e2bf1178ccdcf"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
