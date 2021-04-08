require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.40.tgz"
  sha256 "a60b6829ee683a07e89d23e6e2dea208653e41041e2b405776bb954c4c972da8"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e225559215ba72f0308e5e5be5c90863492efd7982a478cac7866e76dec354fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "556d8185bb07b9704402637065c2ca20e35288305eda37c68aa2fe970238b97b"
    sha256 cellar: :any_skip_relocation, catalina:      "4a17cc2907e2020c86d913d401c90ce97ea4ee3141b09ea07d42878d2ffaadfb"
    sha256 cellar: :any_skip_relocation, mojave:        "bebc36c86286256cfc437b1f431fad91eb7f3c3773c9db178145bd03e1ed1095"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
