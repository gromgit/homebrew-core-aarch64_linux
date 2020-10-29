class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.0.tar.gz"
  sha256 "decc65f8f56b39a8ea12a268fe7bf5fb14da16925f55d7ad2ee2a39741ebab3d"
  license "MIT"

  livecheck do
    url "https://github.com/tfsec/tfsec/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "548aebdd94f2a12a9a99fac9dadabd8c3b2345519a5fdc3a51e53281e5140ce0" => :catalina
    sha256 "cf3dc47f42d831143a69a66f244516a1e86e00b9585b1ff52cf81ba243c20933" => :mojave
    sha256 "a8fb7ac789f879aa64f21a75474519b4c7c98983ecfd5a57222e7704dc690c4a" => :high_sierra
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
