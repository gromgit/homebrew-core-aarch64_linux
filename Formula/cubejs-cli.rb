require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.60.tgz"
  sha256 "37c26d883f399a4405a241ce33cbfedb58fd44abfc38b0b45eb0ec35548c2642"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "327820adba516b679f18ac13c7a5fffc1216b09f499090ccf53875eabefea7fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "327820adba516b679f18ac13c7a5fffc1216b09f499090ccf53875eabefea7fb"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9338f45a7ca97346e060c0b02416b5b85ac245f39e002a76f36fdf3e8684ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc9338f45a7ca97346e060c0b02416b5b85ac245f39e002a76f36fdf3e8684ef"
    sha256 cellar: :any_skip_relocation, catalina:       "fc9338f45a7ca97346e060c0b02416b5b85ac245f39e002a76f36fdf3e8684ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327820adba516b679f18ac13c7a5fffc1216b09f499090ccf53875eabefea7fb"
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
