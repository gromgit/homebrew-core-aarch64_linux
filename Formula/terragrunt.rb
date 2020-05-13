class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.17",
    :revision => "f48b5960a17dcc014ade9906fefa1a3bd6e4ce1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "31cd457e4adc7386be3467c1b5a06b234ee92f5f86d6fec4499f39cc10bac4fb" => :catalina
    sha256 "32986977f95ef0a739f44597294954985451ce41e25158ee9f1b9f2b496734a0" => :mojave
    sha256 "cbc90ce0da002aef755ff2d84bc3a9acae56a4754c6e34d1a37423659f2d41fb" => :high_sierra
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
