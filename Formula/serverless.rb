require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.38.0.tar.gz"
  sha256 "7a04ee77b072ee1e6ce9afb7234f91d85f37f984aab8b46bffbd6f74e3da2789"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "1e26793b29c747ebc37a665b231c8aa8eb84dd653d3e327d4a591218233dbe92"
    sha256 big_sur:       "22bf6bd7bc5ebd3e84a7a0956ad8828f7ee2ec6e1fb9a3f4a63add9d773790c3"
    sha256 catalina:      "8ad6f702dd123396be208abe06464d17d78167b1249d7c69c7a5299ead2ae13e"
    sha256 mojave:        "7c2e9ddbf612c9c466ea9643f60f1cb2f85965fd5b66dc36186ee3172486f424"
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
