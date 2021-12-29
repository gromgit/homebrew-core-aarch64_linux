require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.5.0.tgz"
  sha256 "9380bf3bbd9ae35ab8e6c456329a3fdfdd9e36c1489b5de360652e70f038838d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4056888cbebe7179d8d23654fb684843f0b66b57da0dfcade8e88d71c1976ea0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4056888cbebe7179d8d23654fb684843f0b66b57da0dfcade8e88d71c1976ea0"
    sha256 cellar: :any_skip_relocation, monterey:       "692f4115f13ae843b04526d8063d7f11cd25b2f776748c782525838ac70e39cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "692f4115f13ae843b04526d8063d7f11cd25b2f776748c782525838ac70e39cd"
    sha256 cellar: :any_skip_relocation, catalina:       "692f4115f13ae843b04526d8063d7f11cd25b2f776748c782525838ac70e39cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "131bf474f9f787630ceb8cf73b8c1c81b46d4d797966fec3047d4065fe0ccd88"
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
