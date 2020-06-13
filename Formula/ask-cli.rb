require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.10.2.tgz"
  sha256 "833cbf10f51295334c37f392fa073eb9dbf21671eb8cdb372d8202874c913cb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec4e22aacc596ac747bf23fbfa33b272450b497b48e9cfc7b93fc56cdbb44c2d" => :catalina
    sha256 "64a7f23890e1f791176c7a64ee995f04fd5e4ec07a5d7c3c91d6df2f9233b86c" => :mojave
    sha256 "a1bd2b95221297129120e4bfaf8a4186a2c97597873fd1f2dfca0be45fa4108e" => :high_sierra
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
