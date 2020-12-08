require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.3.tgz"
  sha256 "e9898e13e13ae19336207b7c93b9d6e978d3bc1f30e274559ee364cdfa6c9bb3"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9b0bd80541d0e4f79c702c004b151b0fb7e6053d0a3da52132e4560d3d492a0d" => :big_sur
    sha256 "bee72eb5abce7ea093e3a185bfdc57a9723aee780f7b85a8e1d425cb3d95173c" => :catalina
    sha256 "2573313b18c6732d088067d6e99c34e2138f6ef5c7b847ade0893fddb2bc497d" => :mojave
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
