class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.10",
    :revision => "27e0fb53c45258d183f6fbb347b718554f15dbaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6924802f5cdfd17feae2b561ab9d9dfe72bb6d7cae2083a3b57bd165f2f41d3" => :catalina
    sha256 "146254b4920a19e8bf71b7e50dfcea9c3d49af69ccd81045fd1425bfc8cdf6a0" => :mojave
    sha256 "55281793d4e0871ee1a31c37d88be02f3e50888b7fa762ee17a568d9c689afda" => :high_sierra
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
