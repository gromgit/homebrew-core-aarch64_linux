require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.7.0.tar.gz"
  sha256 "036bf45c778295095ce12edeae6218d6ec02c771947a607bc434ca0054a65168"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c03d59a2a3958fd00eeb3f4012bca14c31ade7ed1eb74432ceca313028a4b45" => :catalina
    sha256 "6dcc2958d718378a08d5c2561b3deaa1cf8c2c627712ddbdd2a3543e59c1bcca" => :mojave
    sha256 "363c5b4090b69a3cd9cdf31e7fa88ab91997bf1c474756ab95e7d9b5eafe9349" => :high_sierra
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
