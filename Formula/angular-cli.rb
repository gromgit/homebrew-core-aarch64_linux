require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.9.tgz"
  sha256 "ceae4fb7620edb11ca9718f6f72b241995b1e25871d3b3929edbc522c7eb7783"

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
