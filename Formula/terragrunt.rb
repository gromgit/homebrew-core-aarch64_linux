class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.25.0.tar.gz"
  sha256 "cf5b57157618930e8662de8bf1c2ff44eee1a36773d3342aef85f63fad2725d3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac8e1f70c04148bd4f43e4be919031ade10620727668f01b2503408fc118a3fc" => :catalina
    sha256 "6b113c11d6ea467765861599c4d27491d0cb52fb1f49a88e19233cafa0246530" => :mojave
    sha256 "172fa3b1141671ded1683e9d1470ed713df3986a41b45d4f2e875ebaf982b61a" => :high_sierra
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
