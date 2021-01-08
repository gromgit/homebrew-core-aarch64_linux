class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.27.0.tar.gz"
  sha256 "2e6e113aa02aee4a8de635900307a87a37d052d2f12427df71b101ef403ce7b1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6cae33c0ab4807b4f30c50ddff622ce8562115d2ea4fa28cb121228029ccbc4" => :big_sur
    sha256 "2fdf6bc8eabb10f246f0a29763e57b5d7745e32f224703e86fd23d10749803dd" => :catalina
    sha256 "96d45f9c15f265c956e5530f0be552ee98016f380c57703744411113718e0a73" => :mojave
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
