require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.33.3.tgz"
  sha256 "c5f5c7ac4cb4d7ed327eda8c6d7a2e8ab24782daaaec4487cb493dd588964781"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "743cbf5293cb54d0b4f5703aed2c09b1e35152c9dffdad3b58d818ce54e17186"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ec25f782d02b83e7961f1dd2cee0f23c2f0c3d49bfc4c52c7a558d3cfb43cda"
    sha256 cellar: :any_skip_relocation, catalina:      "5ec25f782d02b83e7961f1dd2cee0f23c2f0c3d49bfc4c52c7a558d3cfb43cda"
    sha256 cellar: :any_skip_relocation, mojave:        "5ec25f782d02b83e7961f1dd2cee0f23c2f0c3d49bfc4c52c7a558d3cfb43cda"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "apollo/#{version}", shell_output("#{bin}/apollo --version")

    assert_match "Missing required flag:", shell_output("#{bin}/apollo codegen:generate 2>&1", 2)

    error_output = shell_output("#{bin}/apollo codegen:generate --target typescript 2>&1", 2)
    assert_match "Error: No schema provider was created", error_output
  end
end
