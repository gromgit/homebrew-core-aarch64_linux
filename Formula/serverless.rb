require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.81.1.tar.gz"
  sha256 "ba811de2b2390f91c4d2de2ba0bd376b28ef3e15f4eb961e0ac57785a305283f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "15892a70c81f17e2c5f5c0d8bf1a3d2d4f5906f646bc097a4fbb645a2cd3fa01" => :catalina
    sha256 "8c85ca160e96b1cf098c6bda571feeaf847aecb6a1981fc412e97e3d651c6e09" => :mojave
    sha256 "e45d59b7cb648dfb42cc254e4c97b12b585be9b9915836e6dd2dd8e9287dd1a0" => :high_sierra
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
