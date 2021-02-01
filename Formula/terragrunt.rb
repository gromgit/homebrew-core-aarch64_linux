class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.27.4.tar.gz"
  sha256 "7da467acced7451c98808c0f9862858b8a25a291c93fb893fe2714295cb9d809"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "249ad68726fdfc0059f725ac90eb148809ec7ec9ae95ed5ccbeab005f7555b59"
    sha256 cellar: :any_skip_relocation, catalina: "534354f2ab8f06323b7b447681227795b8318f0be7286241a24b58db38577a6d"
    sha256 cellar: :any_skip_relocation, mojave: "887527a4a254f1fb47dd2951c9ad6bc9826b9f6e3e4686ad5ffaa86361e269f7"
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
