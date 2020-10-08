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
    sha256 "b3e021022d9ba33e9ca6960460903ceb77f1d743a5b6ededb419f0b47bc2d03c" => :catalina
    sha256 "008de1cde53b82ac6b860c599f31eb750aea052d99624a3b3bdf39ece258f802" => :mojave
    sha256 "6c43e25ecd12b16283f662086105c2a0f95bbb95b37863a1cd1cdaecfcaf48cc" => :high_sierra
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
