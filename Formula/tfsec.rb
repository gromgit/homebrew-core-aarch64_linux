class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.36.11.tar.gz"
  sha256 "6a8eb979de3815a6702b5dda2176530e7e16bc13bd244e62d420579e9ee4d12f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1851bf8ab54380e6c959094444f3a188e1a539f9d543f28be9a8d29c7610ebf3" => :big_sur
    sha256 "27779361365758a3e44945d4ef7bfd1b83e3dc01c77cab50e199969da6a2a46a" => :arm64_big_sur
    sha256 "558762a9cbab538bf42b8cc2df12eee051e33e02c693d2aec4482084c7ab09c6" => :catalina
    sha256 "f09fb8366c7538ad6073fdfef5a0866dafd0ca870bb85c9feecf6a4836686bfe" => :mojave
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
