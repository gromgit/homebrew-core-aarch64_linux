require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.17.tgz"
  sha256 "94b22ba197d7e8c8b7a33f8faedfecb057d330e001e9693ac1dd1449c66e056c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d56d041c8d6748699494d09b2a4d4d355daa76913388fefb4a66d9f3f5f4db4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d56d041c8d6748699494d09b2a4d4d355daa76913388fefb4a66d9f3f5f4db4"
    sha256 cellar: :any_skip_relocation, monterey:       "0079f42da773cbfa37515ca7acdc8b622f9602b9250f9a571eeb053cc399f846"
    sha256 cellar: :any_skip_relocation, big_sur:        "0079f42da773cbfa37515ca7acdc8b622f9602b9250f9a571eeb053cc399f846"
    sha256 cellar: :any_skip_relocation, catalina:       "0079f42da773cbfa37515ca7acdc8b622f9602b9250f9a571eeb053cc399f846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d56d041c8d6748699494d09b2a4d4d355daa76913388fefb4a66d9f3f5f4db4"
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
