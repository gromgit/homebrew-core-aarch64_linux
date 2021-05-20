require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.43.0.tar.gz"
  sha256 "a03a15f6a3cec6b7c9531b7bf7fc41b0357c91363676b08adab81f2ba1571791"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "901333462f2b277c3adf347c77b0f02bd31adb5fdf09c6e3582cfdad92bc1477"
    sha256 big_sur:       "e21b543469cbfb174bbf2b27ce224fa32bf7a0ba87ce0c06167c64774e115b06"
    sha256 catalina:      "048998f7b43db1dc470b72c9e6d18c7568ec34a3e3707e84148afc8d475486cd"
    sha256 mojave:        "870f081222414920b92241bf8c2ed2b6747ae6b5ec85cf283e197f704f9dba21"
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
