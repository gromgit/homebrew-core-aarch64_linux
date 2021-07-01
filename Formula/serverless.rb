require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.50.0.tar.gz"
  sha256 "5cf8e7da3002e5c26a62b4bbe94ab41311777c84831a3748d241737f72c338dd"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "3564fe9c282852c65d02cfb1f7a8023d29db4c181906355f289ba6fe25fd5947"
    sha256 big_sur:       "c41b15ba9f1822f8dc1e3e893e65059e8fd7ad7e2c513557a30c0ab423d4f036"
    sha256 catalina:      "ebdd08434bea9baecd065f09ab0ab856f338f584ac121d8021d890714390c0ad"
    sha256 mojave:        "5202ef495a27fd7b809bc96db480e5a0a0084cb07b4f90b4b83852e30053ac55"
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
