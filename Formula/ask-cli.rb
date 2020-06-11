require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.10.1.tgz"
  sha256 "f252a34d67ca6cf6f43e301626ffc1794df5a2c7dfdebf76649840b82af2ec38"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd95a7a8a93f72f0436e9d651ccee822ed1b674304cd1046f7cad4450d99645c" => :catalina
    sha256 "3f704fa9c25108ae53bd40740a79d07ee3febd2d28a53c2bc3a8bb82e9b3653b" => :mojave
    sha256 "0f27e4fc8fd20e3caa16f8001726da9b1cfa2694810eed0024c3d602f644dc8b" => :high_sierra
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
