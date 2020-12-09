require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.21.0.tgz"
  sha256 "04b7a78d9e17ebb7eb90356b6959ee73b821d6e072190f8965c784555782ef14"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dc2534a94d1e025fcb2cee11f0464eb1f2eee52ff16aa5a25856ebfd9de5e69d" => :big_sur
    sha256 "874891decbfcdd0cc14c763ff6ee7788e80df09d4b39f3ada55554bd5d9c6ff9" => :catalina
    sha256 "25257436266db197a29f26b07203ee8651c87afbf7724241701216eb17479485" => :mojave
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
