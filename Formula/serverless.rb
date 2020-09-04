require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.82.0.tar.gz"
  sha256 "f5a78a3bf4401f6c048270c3a287a7737eb431f4225b8a0da163fe8db5b48205"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4746a184ac0aacbe197527d5b7c0e7b640fe4eb0d42fde5ca1c2843e0fcc688f" => :catalina
    sha256 "16c0dde9b30e1256ec49db6b945c35fc7730cf7d069e7c927f12deb009cb0b94" => :mojave
    sha256 "7853fb44b1f3e123abb86941b54047e5742cdeb1862717ca5d9a7fe4a88d1c9c" => :high_sierra
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
