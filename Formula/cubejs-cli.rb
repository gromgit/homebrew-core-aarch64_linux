require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.46.tgz"
  sha256 "e029ab2338e8da8fc3aab028512df7465194c28265479d77fa0f87dc9a9308f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "206b969d359665377faacadb3bf95291c1e9eb3ca6709d64a4fee92d9bad3940"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "206b969d359665377faacadb3bf95291c1e9eb3ca6709d64a4fee92d9bad3940"
    sha256 cellar: :any_skip_relocation, monterey:       "a42fb499060316caa843e02bc5c7eea2ed06bcac451df0044b08e41e789a88c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a42fb499060316caa843e02bc5c7eea2ed06bcac451df0044b08e41e789a88c6"
    sha256 cellar: :any_skip_relocation, catalina:       "a42fb499060316caa843e02bc5c7eea2ed06bcac451df0044b08e41e789a88c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "206b969d359665377faacadb3bf95291c1e9eb3ca6709d64a4fee92d9bad3940"
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
