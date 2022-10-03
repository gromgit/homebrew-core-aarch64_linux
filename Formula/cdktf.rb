require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.12.3.tgz"
  sha256 "cf750385d9aa2293da3ea87f9f5f067b761c701c5263fdf5a7e8bf2a040c9b8c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e951cf455c4e997ea271b57615fa46ef7d64cead8388479de01c1fcb4b2b8eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e951cf455c4e997ea271b57615fa46ef7d64cead8388479de01c1fcb4b2b8eb"
    sha256 cellar: :any_skip_relocation, monterey:       "4c3c8c6aec43b636cba2d31188b0b12e31c5872d18aa4d76d3c81c1ef5753abb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c3c8c6aec43b636cba2d31188b0b12e31c5872d18aa4d76d3c81c1ef5753abb"
    sha256 cellar: :any_skip_relocation, catalina:       "4c3c8c6aec43b636cba2d31188b0b12e31c5872d18aa4d76d3c81c1ef5753abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e951cf455c4e997ea271b57615fa46ef7d64cead8388479de01c1fcb4b2b8eb"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    generate_completions_from_executable(libexec/"bin/cdktf", "completion",
                                         shells: [:bash, :zsh], shell_parameter_format: :none)
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
