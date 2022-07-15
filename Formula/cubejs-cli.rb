require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.35.tgz"
  sha256 "24f2e8068b9434b2c6a8ab12ca1a9df476851f66c206b3c52bce936f03c2c5f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2648ed40b3e76ad4a7c627358a57e56b7401fab16fdc90a926545205a774281d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2648ed40b3e76ad4a7c627358a57e56b7401fab16fdc90a926545205a774281d"
    sha256 cellar: :any_skip_relocation, monterey:       "a23bc1d419cd642f10fcd9e46c05c36b3cfa39ceebcf9c01834b8fe26015a9ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "a23bc1d419cd642f10fcd9e46c05c36b3cfa39ceebcf9c01834b8fe26015a9ae"
    sha256 cellar: :any_skip_relocation, catalina:       "a23bc1d419cd642f10fcd9e46c05c36b3cfa39ceebcf9c01834b8fe26015a9ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2648ed40b3e76ad4a7c627358a57e56b7401fab16fdc90a926545205a774281d"
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
