require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.20.0.tgz"
  sha256 "52f284a031c8e07a5c03eb42aa80b69728bdf32154d573e415fd20741030ecb1"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a1e1c843a99423831f8fb2af1a1130d98bcc8cd2d4b8bd3740f091a9cce0345f" => :catalina
    sha256 "0daab6ab4fd2f156ab0a8364e3a6490df2edb562877ce3f329c2d012a816dd6a" => :mojave
    sha256 "00c47456c7aefd69be4707a4771d7d998cd0372100a97fcc5f8187b43b473a92" => :high_sierra
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
