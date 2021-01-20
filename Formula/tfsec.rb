class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.15.tar.gz"
  sha256 "c5d8f24100004467f8f66539fed6b53b726b17b486b57bbff3ad098bb4579222"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5aea4667d2c73eced1d261dfc03de0c1c4b2bb2bce09dff5941250f315f8aa43" => :big_sur
    sha256 "2a7479b7d82b88da6ed8bf8da7491ff19c72a1a1e72123899deeaee1cd350b21" => :arm64_big_sur
    sha256 "704eefd8e16eeadb84d23d398f7a0e10ddfd6ae946d29a8ac3bdad80d0955d1c" => :catalina
    sha256 "82719cc6567b0b73e1daafa825a06847fbe866fe46ca032a6d9eb8c95c632ef6" => :mojave
  end

  depends_on "go" => :build

  resource "testfile" do
    url "https://raw.githubusercontent.com/tfsec/tfsec/2d9b76a/example/brew-validate.tf"
    sha256 "3ef5c46e81e9f0b42578fd8ddce959145cd043f87fd621a12140e99681f1128a"
  end

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    resource("testfile").stage do
      assert_match "No problems detected!", shell_output("#{bin}/tfsec .")
    end
  end
end
