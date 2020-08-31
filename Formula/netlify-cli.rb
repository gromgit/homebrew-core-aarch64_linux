require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.59.3.tgz"
  sha256 "bce213b07c871bcf22407a8ff8189473aba5d725bf2a4cad88a54648acbc9ece"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "878ae1d189aac33a3717f1d5194631384d956447637c59af911e70b00b6dab4a" => :catalina
    sha256 "18e6421e7fbb24de68ebdcadf8ad458bb39d4a234198d4eae5e127e324e7d33f" => :mojave
    sha256 "76efe965494d65cd86296d5901cc1122d2918d6b6b629d053189aa02256678be" => :high_sierra
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
