require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.23.0.tar.gz"
  sha256 "d3e882a27038a2aa4bbb8cb2b6c42ab73a4fe2fd9dd39dc46573652d5c44af9c"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "2c92e4e08610d5f2ef69cd7366dba474267de182049e8389e6a0f738bca9be15"
    sha256 big_sur:       "6f37f7352b1ca2b7cf67d6b1e3bd9cb52caa073dc19f83140d98ae2791bac22e"
    sha256 catalina:      "69d769aa4edf30f6769b4d7ef406db181f4799d7f1275dd495ae444d8db04d8a"
    sha256 mojave:        "2b2bf1985501892d55458d1821f95ee197a332cdc9ecafa346f3b6a43fdf90bd"
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
