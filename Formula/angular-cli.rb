require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.6.tgz"
  sha256 "de5d8878afe49de63d152488cf5c08af28e12163a66fad8bbbf51f45c1e9f81f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a31087f5c219c68f216a7c0d213933ac23c0d80927c9cd2b111e027fdfbcd00"
    sha256 cellar: :any_skip_relocation, big_sur:       "cca506584f0214d200599bac3c989c6179a1824706899b86c804c12527739221"
    sha256 cellar: :any_skip_relocation, catalina:      "ccbb5c5b080c9b96eea27b6f459bb3d9bb40cd2cfb319cd32797d19eba4cd8c8"
    sha256 cellar: :any_skip_relocation, mojave:        "c5ff7a7b2e90c8dbbf4b6ad7b7a7bab409194f23a91a9e9d8db325e6bd1651e9"
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
