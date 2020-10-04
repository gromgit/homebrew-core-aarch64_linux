require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.65.0.tgz"
  sha256 "4f1bc4bff55ae11eb490c50056073f501bd1e46ad881f67e261ad34a04389e00"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "df6b0b7cdf41cb9219d18ad9ff2a2c593a9a2bd04e2867bd174aef57943d0a74" => :catalina
    sha256 "9132087030af63f7f17e5e85d79c2df0c0f3f0a574b33d452a271fea44f12036" => :mojave
    sha256 "ff33bb120f98f6fe1c99bb1ee99a5631b2cda207462dab3eaaddab87aa41818e" => :high_sierra
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
