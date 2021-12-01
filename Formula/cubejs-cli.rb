require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.61.tgz"
  sha256 "de3ab78dec52802aad009af4adb87bfbff689a9c1323fc7ef72bb50a72792424"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02e86cb34ce020390ff7ba183b36ca9a4a54df164eb0fb40b42bafa0fd27cefa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02e86cb34ce020390ff7ba183b36ca9a4a54df164eb0fb40b42bafa0fd27cefa"
    sha256 cellar: :any_skip_relocation, monterey:       "49ee3828c385d236bfc588bea91a6735412a36cdb9cae136c6a8f00023d7e475"
    sha256 cellar: :any_skip_relocation, big_sur:        "49ee3828c385d236bfc588bea91a6735412a36cdb9cae136c6a8f00023d7e475"
    sha256 cellar: :any_skip_relocation, catalina:       "49ee3828c385d236bfc588bea91a6735412a36cdb9cae136c6a8f00023d7e475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e86cb34ce020390ff7ba183b36ca9a4a54df164eb0fb40b42bafa0fd27cefa"
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
