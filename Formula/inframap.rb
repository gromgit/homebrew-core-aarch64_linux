class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.5.1.tar.gz"
  sha256 "1384b4a1629d323508ec21905ebfc38b4cca85915c8f5665b27492d4f403ef1d"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c5ab56cf2b6a57e25bb2122c99feaed04599e70ebfe3f76f8fcd1aa0f3869dc" => :big_sur
    sha256 "762e1b64331df8b6174eefe8b56cad13e76f6c13ec5fd369fa2d374f834d675d" => :arm64_big_sur
    sha256 "4bc07dd6c389c33a639f584b3407d53a679459425e8c4197470f0183d845c31a" => :catalina
    sha256 "afdd706328b6fe63d321b88af82dde0e763a271c4a6a404f842885f55fc2af9b" => :mojave
  end

  depends_on "go" => :build

  resource "test_resource" do
    url "https://raw.githubusercontent.com/cycloidio/inframap/7ef22e7/generate/testdata/azure.tfstate"
    sha256 "633033074a8ac43df3d0ef0881f14abd47a850b4afd5f1fbe02d3885b8e8104d"
  end

  def install
    ldflags = "-X github.com/cycloidio/inframap/cmd.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/inframap version")
    testpath.install resource("test_resource")
    output = shell_output("#{bin}/inframap generate --tfstate #{testpath}/azure.tfstate")
    assert_match "strict digraph G {", output
    assert_match "\"azurerm_virtual_network.myterraformnetwork\"->\"azurerm_virtual_network.myterraformnetwork2\";",
      output
  end
end
