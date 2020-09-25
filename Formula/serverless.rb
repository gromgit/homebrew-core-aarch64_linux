require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.3.0.tar.gz"
  sha256 "2e88bf0450e1fba2eac4061df3c0b1bf287ec9fe9266b7f21b4023d82b8d8741"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4baf35ef61719c8901e6ac4c5872b1cd6da593c6b96b3eb7e616da54d01210ec" => :catalina
    sha256 "a2b8772ee372d77cc41ca6ca3b516f76b0ce6cd48cf155902bf2ebd31e2a4bf8" => :mojave
    sha256 "6bb00e2f2f467b713021b94b9454db605e92b5e9318916c0b48dd1e382fbdb76" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
