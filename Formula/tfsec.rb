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
    sha256 "fb356de736aa8709bd9f71216bb980ada7fe5ebd08f1fba3416a948950ad42aa" => :catalina
    sha256 "edfcce7ed57850cb5b6b47a35982b43759953035f58871452e2624a67e89af88" => :mojave
    sha256 "3816aaa90ae75e726457b5dee00b5f3ec45051e43075f71142d95a176f483ed9" => :high_sierra
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
