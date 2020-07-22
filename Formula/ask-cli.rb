require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.13.0.tgz"
  sha256 "23fbbcab40e34ddd9741f188afa39d0c417b3466d9f9af75ec0a69eb176a94de"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1f75b0bac95696f15e19715c58bc1aa1944558081a24dc313c441b3fc2ac046" => :catalina
    sha256 "78c07c7c971093c208e6a3a10d98da5ae1a762dc4212b5016f420a38470c5672" => :mojave
    sha256 "0b1bf52213312ca88938aed2db85a23cf552832fc05f9a7a7e3f4e4272a7d6f1" => :high_sierra
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
