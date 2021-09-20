class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.32.3.tar.gz"
  sha256 "ccd223562f849f3d81829e33d4fd2fc89df20b3dfe9aaa9fb3d5ff63ee21dd89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29cf8123fbb8e1b5ffde6371c3b30e9583f2b6a67362626c9c8788e77641da6e"
    sha256 cellar: :any_skip_relocation, big_sur:       "4bfa8430f334c44d8ec076bc62117de81c2bea90e49a64d51d634208d6000359"
    sha256 cellar: :any_skip_relocation, catalina:      "fbde752d5234eb30e7fc20d226ecc92b7f8b05d89bac09d11965dee339e727fa"
    sha256 cellar: :any_skip_relocation, mojave:        "2786af87c340f0a404530b1eb0d80e73e71618af4b316ef01572b0d02c9504e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed92b9dcce718d1f66e5c8870d72efb85064a754420922547ce54a0b41e9220"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
