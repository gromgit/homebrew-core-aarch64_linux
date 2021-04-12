class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v0.0.6.tar.gz"
  sha256 "2dfcca8d6108da9cf03367f8357bed87f76d782f1001049819164e7b50841e6d"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e89dbcd3bcf789e2606bdfd6db02eca549a2cf886fc01f6028afe0bc2b0805e"
    sha256 cellar: :any_skip_relocation, big_sur:       "229957ffa6a357e5e87cb8263aadd3a79b412f8a6fd451db15eca2c9f41c89a6"
    sha256 cellar: :any_skip_relocation, catalina:      "af6be26588640dd3c96d746fe6bb1c29d64aab8de00bac71db13d5243df8f10d"
    sha256 cellar: :any_skip_relocation, mojave:        "7a20aa6d05fd86d72486b8369c48936ccc07e0477c5d9ccc83e83af2d9a96779"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
