require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.1.2.tgz"
  sha256 "d439c49b179a3da8c482ffe93b3b27a2b2ba78a9a2c2b373b5790c56ccbc27ae"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "54910ad81accbcba059e3b8a567690dffaaee7322e765a7e77a57cb35475a8bb" => :catalina
    sha256 "f259877647d8e838b155ca659a65682a3347208986c1313c958832c8bbcd187a" => :mojave
    sha256 "34c2767e2d9bb2da0c9ae403bb86e29ee718f193bb73e80e4ee767d5b0d562f2" => :high_sierra
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
