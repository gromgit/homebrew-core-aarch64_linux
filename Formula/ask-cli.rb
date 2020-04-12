require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.0.1.tgz"
  sha256 "8be5a30551024a8e790f4a2bd42bd49a9346a448b5bd7db0870967b8710c22e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0527cd865281fa5c35a67ac79a0981356251dbbe4803ed7057d17cae1d79de26" => :catalina
    sha256 "02a4d87a6f469db4339c76f3dde5f59a5ca8e511ea953a67b22a2745482f1d37" => :mojave
    sha256 "4f984c1303aee9f3ee8032231100835550e2d6c980c37a4ca57c7912927d9980" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "cli_config not exists", output
    system "#{bin}/ask", "lambda", "--help"
  end
end
