require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.31.16.tgz"
  sha256 "d5a6f13dcd347a9169c99791f5da460d6b2079fd72d5cd1d94fca3726175acab"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e63f43776d02c41f6efcfa8de381837df304eeea0ac2c5346dbc54da5b54d5f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "efb36b8c0e113d1cef192ab2dc8feb8d1c078390dd7e1af217b611db47a3212a"
    sha256 cellar: :any_skip_relocation, catalina:      "efb36b8c0e113d1cef192ab2dc8feb8d1c078390dd7e1af217b611db47a3212a"
    sha256 cellar: :any_skip_relocation, mojave:        "efb36b8c0e113d1cef192ab2dc8feb8d1c078390dd7e1af217b611db47a3212a"
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
