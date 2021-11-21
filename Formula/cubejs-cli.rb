require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.59.tgz"
  sha256 "7a437f0da44babf3e8d14973fae6c43bb87695dd60e2de738044c5805fd0543f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1e3c5da32f23465aef20e3f9599a60b4ac15ec6e07b029a302a25aac291d46e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1e3c5da32f23465aef20e3f9599a60b4ac15ec6e07b029a302a25aac291d46e"
    sha256 cellar: :any_skip_relocation, monterey:       "1acd854d68df52b90b029bb9da34497783c5a07d66aa6839dbd4b07cbca4ebb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1acd854d68df52b90b029bb9da34497783c5a07d66aa6839dbd4b07cbca4ebb8"
    sha256 cellar: :any_skip_relocation, catalina:       "1acd854d68df52b90b029bb9da34497783c5a07d66aa6839dbd4b07cbca4ebb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1e3c5da32f23465aef20e3f9599a60b4ac15ec6e07b029a302a25aac291d46e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
