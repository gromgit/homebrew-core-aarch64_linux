class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.6.tar.gz"
  sha256 "2ee150aed3d0a2e171a56d5b194d2e4746259e644cf1ca53d43da616157d20dc"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "970217f2e6e129d7f079909f5cac09ef9491e793fb857056b424f0f224ae52cd" => :big_sur
    sha256 "9ec3458abf76ecb8f13cc7164cd8fb022d3c3fc336061f04990f140039ff2033" => :catalina
    sha256 "0fd68decd0c871d1cc84f8850313da4077859d3998716d8b4e465ddce5ae41ab" => :mojave
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
