require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.8.tgz"
  sha256 "d508573f8120d628c97aa87b28bf81785cc64524e2045c277dae9de3456fe949"

  bottle do
    cellar :any_skip_relocation
    sha256 "73b2deb6172c6bab2a97226bac8510d08a78d08501fc149d4229531ce13a02dc" => :catalina
    sha256 "f24029db441632ecdd7f7fa91d4833c4f9012e73a4c5b7194a8254ca72ee0d06" => :mojave
    sha256 "1095d8d7c5360b6749681e780eb0f26130e3ac807b6b15f59233e6263a87f552" => :high_sierra
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
