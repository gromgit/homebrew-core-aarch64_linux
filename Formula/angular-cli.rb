require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.7.tgz"
  sha256 "d614a05bfcbb5104a4816a118c0a04790cd4124b5e702e0591f38251066c2e5b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7a90dfe6dc7f46d0fedf43ce2ca3640732b6180198530a8e754fb5c45b84598" => :catalina
    sha256 "dd41a097ad506a5a8edcf4762b4e3d91c5878b6d705954758d70ca8ac05b727d" => :mojave
    sha256 "9b610098da5c6e85270df32724bb832596fb633166458be27e857f90ea783e56" => :high_sierra
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
