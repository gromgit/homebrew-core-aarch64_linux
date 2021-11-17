require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.57.tgz"
  sha256 "c49c235c015d2e292f26c2fb20582b872d2d1924291a0d25b13728d6776f4c77"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7be4a4835493067f1afbcf725a36403a6f25a884850cdb79ed0fc253d724db63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7be4a4835493067f1afbcf725a36403a6f25a884850cdb79ed0fc253d724db63"
    sha256 cellar: :any_skip_relocation, monterey:       "5aeef168acbd8acb0ecb12eef91bb4d101e10dd2501a5d73029c4df245b20445"
    sha256 cellar: :any_skip_relocation, big_sur:        "5aeef168acbd8acb0ecb12eef91bb4d101e10dd2501a5d73029c4df245b20445"
    sha256 cellar: :any_skip_relocation, catalina:       "5aeef168acbd8acb0ecb12eef91bb4d101e10dd2501a5d73029c4df245b20445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be4a4835493067f1afbcf725a36403a6f25a884850cdb79ed0fc253d724db63"
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
