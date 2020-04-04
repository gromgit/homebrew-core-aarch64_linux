class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.5",
    :revision => "7cf1056d1acb9fee781312126371c69bf732ab59"

  bottle do
    cellar :any_skip_relocation
    sha256 "98a9b85f3cad861a76e19e5cf647a960e9b5d37a6f4e8d45a0da71b17519de1a" => :catalina
    sha256 "7ead7db0a7b768e7d14835ab601e99887d79b3e88b9fe15e5017a56ce6fd0d49" => :mojave
    sha256 "d0fea8e490cc94d2075b202565133cb4aff275209fe688f05557e34512e7e7cf" => :high_sierra
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
