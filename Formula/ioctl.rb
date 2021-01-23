class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/developer/get-started/ioctl-install.html"
  url "https://github.com/iotexproject/iotex-core/archive/v1.1.4.tar.gz"
  sha256 "8bc4aca80ba4a51d24aa706327600150c7fb632d76f59da0e1633076b75d420a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a4ed6686010c057740b3034deac2213f2c3dd6531be061f3f723ce71d368d70" => :big_sur
    sha256 "91ac4733539093413bf3d8bc3b4beac08589917ef84434bba5ddc61cc49a16ca" => :catalina
    sha256 "02c80614399fc92d2425b34b00931acd20c689d93a588a1adcb137d8b60ba807" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
