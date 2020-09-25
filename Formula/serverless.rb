require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.3.0.tar.gz"
  sha256 "2e88bf0450e1fba2eac4061df3c0b1bf287ec9fe9266b7f21b4023d82b8d8741"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a7cb7c259e260372665f96f64319a7d579f8ffb8b670a2230f02d1194256984" => :catalina
    sha256 "619e189d9e9909f35db86d681f97c0d7db463c43f4458829e6a75dab40786b9d" => :mojave
    sha256 "c8033488f0078078abd337b13d38da75c1baba0fccfaea8f7b485cc22e0a7f79" => :high_sierra
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
