require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.0.0.tgz"
  sha256 "a4efc25718689151528c2ca5ba419b8f7486ac1066ba4bd6aeb3ca23b5dd5a30"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "96d1e90d2e23dfd48119c57a16501866379cc3c4893b375a5696d9b1eed91f6b" => :catalina
    sha256 "ae593b7e7a9c2271de11fb001a29600ecae00be258974b5c615fa8f07cee542d" => :mojave
    sha256 "c0afff1c74727f520c85802d7b0f99a679cebcd626157274a5c7af3e9f91de7b" => :high_sierra
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
