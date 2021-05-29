require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.23.tgz"
  sha256 "55bd23afb124dee021f015e773a4d8dba918c75e41c35f716d0a951f71c4f722"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "95f4a210c36d4bdc361a230227818d4a163e7bd64c8c3662078d88e58611519f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e87ea69970de159bcf6cd98553bd5301998b4f64203b0a03400e2c9fbad78a30"
    sha256 cellar: :any_skip_relocation, catalina:      "e87ea69970de159bcf6cd98553bd5301998b4f64203b0a03400e2c9fbad78a30"
    sha256 cellar: :any_skip_relocation, mojave:        "e87ea69970de159bcf6cd98553bd5301998b4f64203b0a03400e2c9fbad78a30"
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
