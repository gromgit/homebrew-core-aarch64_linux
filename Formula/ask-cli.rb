require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.16.1.tgz"
  sha256 "bffe86ded337ba1b6a3cd8a46d7ea4b3806e6fc7567b4e9d1ce3e3d6cca29f29"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "05809b895d76d4af76d61d46d7f9659227ef7bb9eb07b48d66d52e28afabf962" => :catalina
    sha256 "a1a611321fdce05d28bf983622f755236667035e84a302777d9afb3f5b2e909c" => :mojave
    sha256 "92b585019b06e3669a5c61f80aa883b9364b828b96baa1c3e26f996e648a15fa" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
