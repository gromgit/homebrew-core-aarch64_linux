class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.28.tar.gz"
  sha256 "531638e9505b5188c83651176607af82d259dc284b680e8ca662bc6665fe56d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "92b9cd48d1364b03b9ee0203560f3d27c3be1ea56372301023604a046203be1c" => :catalina
    sha256 "4e1bb157369b3554238ea8ea62f39f7b1a4100ca63a563e6a5873673d170645b" => :mojave
    sha256 "8c9f579b1dbd5760349a15048104f46b204323a3ac319646bc952f63c873694a" => :high_sierra
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
