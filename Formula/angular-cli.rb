require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.3.tgz"
  sha256 "e9a3a58652fae99b877aeb2ebd49540a6b09e29580947e106ac2429406840b12"

  bottle do
    cellar :any_skip_relocation
    sha256 "27d4ead82d296acf70891ac78747e881d3e19ec4a7bbbb60c690489ea2db0c29" => :catalina
    sha256 "fdc506f6e139e7dae5627151e8546625505005b60937d55dee56e8a6948d45ac" => :mojave
    sha256 "b0a411541f6575d5a3e50e8f06c4b8a0f7a852a2c0cb6d3bcd019304b4e932f3" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
