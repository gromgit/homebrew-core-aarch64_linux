class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.39.1.tar.gz"
  sha256 "f4921b3f4e7b73420e293a36c7d1417896a397bbad593f07bae666110ccca02e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60a1934348af77df146fedd4ce057e3d0e6ce5263114e0cf4a229b4de18579fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c15b3af6b87101f7e1e42bbfde0cecdd24065b96d3024fd4e5f18ee7a5f4fb6"
    sha256 cellar: :any_skip_relocation, monterey:       "cb6fadf07b7ee8c546b7bf96c7cb36faf1c9ab210db996579ee1c91086530bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4e8cd4944635d8c6972d4e38d955d4ab69a64944910af56de71b49b304963d7"
    sha256 cellar: :any_skip_relocation, catalina:       "d280fbe04b662f02ea4ae330ac0a435ad5423b6c964c83aed1882e1c05f23cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95819a91e173559436a7086795c0286622b8237c9a70fe7d395337b0a70429e4"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
