require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.53.tgz"
  sha256 "6500ab3288e827458e76535164855fe42b9273166d305bc7163408726a09994e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05a4ec79a409333931ab0f382ab2709c5d95c07f5a4169f75e6d4a7733148466"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05a4ec79a409333931ab0f382ab2709c5d95c07f5a4169f75e6d4a7733148466"
    sha256 cellar: :any_skip_relocation, monterey:       "6af52176becd1f876ee027ea56e3721e46039759a84c05eda5bfff23e704cbae"
    sha256 cellar: :any_skip_relocation, big_sur:        "6af52176becd1f876ee027ea56e3721e46039759a84c05eda5bfff23e704cbae"
    sha256 cellar: :any_skip_relocation, catalina:       "6af52176becd1f876ee027ea56e3721e46039759a84c05eda5bfff23e704cbae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a4ec79a409333931ab0f382ab2709c5d95c07f5a4169f75e6d4a7733148466"
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
