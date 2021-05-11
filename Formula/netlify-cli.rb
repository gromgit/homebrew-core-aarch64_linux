require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.29.5.tgz"
  sha256 "d5d9b8bb583a3e1d3948457a9bd6ad04fab0d3ff9c7a84a524d578c18e5551f9"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe2d6cfc51fdc341afd74297a96995f0724f92fc8258dc35768b5a1bb4d281ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d03a791d51da2c4e3439a2b23f920c7f295cb56acfe917f083edddfb7a235e6"
    sha256 cellar: :any_skip_relocation, catalina:      "4d03a791d51da2c4e3439a2b23f920c7f295cb56acfe917f083edddfb7a235e6"
    sha256 cellar: :any_skip_relocation, mojave:        "4d03a791d51da2c4e3439a2b23f920c7f295cb56acfe917f083edddfb7a235e6"
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
