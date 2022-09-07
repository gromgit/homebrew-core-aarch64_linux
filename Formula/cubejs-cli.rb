require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.55.tgz"
  sha256 "d21535283272cf6e48be984cbd8a2e9928d42975c4027dddbb07c0214d19e7fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ae980a22a996af3d3ef39c2e5ca6882d2f8bead1db2e124133ec61af26b311"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73ae980a22a996af3d3ef39c2e5ca6882d2f8bead1db2e124133ec61af26b311"
    sha256 cellar: :any_skip_relocation, monterey:       "02472c2edc672a1069fdf94f6687a9ee2873427c6c08b6dca5c64997182fd4ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "02472c2edc672a1069fdf94f6687a9ee2873427c6c08b6dca5c64997182fd4ee"
    sha256 cellar: :any_skip_relocation, catalina:       "02472c2edc672a1069fdf94f6687a9ee2873427c6c08b6dca5c64997182fd4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ae980a22a996af3d3ef39c2e5ca6882d2f8bead1db2e124133ec61af26b311"
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
