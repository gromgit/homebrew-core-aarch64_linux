require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.1.6.tgz"
  sha256 "044316a546453306cab032751c1cbfe060a9e117a1caf31918a2dc87895ab48c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e3e7a476faec47d473a03bf008a59d704cb3e94a4c7e391241b87174593b5ec6" => :catalina
    sha256 "d9708bd935aa79300d09384540c848a6d325d8814765edecb8e0a2f4c1fc8b9a" => :mojave
    sha256 "0ea4ebea55616c006fe14699a2ba82fa12b0e9a06cd42cd6b9c0e31e2e044b63" => :high_sierra
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
