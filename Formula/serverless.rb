require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.19.0.tar.gz"
  sha256 "dcb68255aad71b02c1d2f3b641b644a6fc00eccea5948e17a027e597a94a8d66"
  license "MIT"

  bottle do
    sha256 "38b0ce92f3a3704d5cfc0564521c08c862f3c917e21715f4aed99023ed74dba9" => :big_sur
    sha256 "abc4812f3bfe1a83265da9251a6d188aa78f914c77ee27317dabef854e777c34" => :arm64_big_sur
    sha256 "1aec8536beab8977bd557e6fbcf93a4f6c7e1f258bcd0bc5831242ac21016ec8" => :catalina
    sha256 "dc4a0f6e72b8a902a5ee379042b33d107991f0e900929205213ff43201c7006b" => :mojave
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
