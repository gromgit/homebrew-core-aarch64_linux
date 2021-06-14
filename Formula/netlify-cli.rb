require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.37.22.tgz"
  sha256 "c4b20ad6d08f26372b4ecac402d64d41af477eaf422086459a7f230075ff9b04"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5bfb2e1a9a7f95809fff0622ec9f79b920b7cf09d257081ef1296648fbb2a49b"
    sha256 cellar: :any_skip_relocation, big_sur:       "17232cb06df8a7c9021d8867bc05e1728559e5f10d6c9d8b809dc9e8eec050cd"
    sha256 cellar: :any_skip_relocation, catalina:      "17232cb06df8a7c9021d8867bc05e1728559e5f10d6c9d8b809dc9e8eec050cd"
    sha256 cellar: :any_skip_relocation, mojave:        "f0c9aa4d11da62883c8a50e1a4c4de74bf9aae1c171e23f89c199a71f7b8ce58"
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
