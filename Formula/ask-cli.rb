require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.1.1.tgz"
  sha256 "38327a8f9cc52129084eb7b9eb6d8dc1fadb91ff4a21361e4dd99cc56492dc20"

  bottle do
    cellar :any_skip_relocation
    sha256 "6707f2e36438884ae7be9481e56ff772683c55e6f01cf2cd16a2995ba752a1ad" => :catalina
    sha256 "f9117a20e0e289ea4649f92fb5436f329791c4d3d3733252f394231466d15dcd" => :mojave
    sha256 "c23a9466f0d42bd3ae33bdce1324026b7c4ce18102826c7c9f443c3584ae82c5" => :high_sierra
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
