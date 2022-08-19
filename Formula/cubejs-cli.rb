require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.53.tgz"
  sha256 "6500ab3288e827458e76535164855fe42b9273166d305bc7163408726a09994e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abd7398eb08dbcea2df8b336762cd01e013b67a28b19407430d9291770ef0b66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abd7398eb08dbcea2df8b336762cd01e013b67a28b19407430d9291770ef0b66"
    sha256 cellar: :any_skip_relocation, monterey:       "7d509d46b0478c5052227fb252b943a4cacff8f87ecc71e3e9dbdba2190dc978"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d509d46b0478c5052227fb252b943a4cacff8f87ecc71e3e9dbdba2190dc978"
    sha256 cellar: :any_skip_relocation, catalina:       "7d509d46b0478c5052227fb252b943a4cacff8f87ecc71e3e9dbdba2190dc978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd7398eb08dbcea2df8b336762cd01e013b67a28b19407430d9291770ef0b66"
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
