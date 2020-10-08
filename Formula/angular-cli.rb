require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.1.5.tgz"
  sha256 "50079304deb282f0031a624bbdeae712ea932d3f3671a597fa983f7929fd2e56"
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
