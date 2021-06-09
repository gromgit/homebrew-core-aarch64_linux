require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.37.2.tgz"
  sha256 "a65634cd3d06479f62e1c0cb3b3220f2f0c6d999a8dbefff49a6e86ed1838745"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9729c3464263c184ccfa36286df7a9d208d0697dd81fa9a1e3b57aaadcd5b09b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f74b4fbccc0183467dd6d856e0e4688f3ef812b26490cdb4b6d8b7adabde74e3"
    sha256 cellar: :any_skip_relocation, catalina:      "f74b4fbccc0183467dd6d856e0e4688f3ef812b26490cdb4b6d8b7adabde74e3"
    sha256 cellar: :any_skip_relocation, mojave:        "f74b4fbccc0183467dd6d856e0e4688f3ef812b26490cdb4b6d8b7adabde74e3"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
