require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.30.3.tar.gz"
  sha256 "52ac116018774e93a4780af8d4c23d65a20b074c79b6cf5ccf11c6560631c4a9"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "c84abd1220760fabeb1723a94bf6036829877d84749e8d85134276570264f2ae"
    sha256 big_sur:       "22fad978e2fc86cbd7d0903ab9ce122c2c13a3e6789b5d156276de52b5420d32"
    sha256 catalina:      "ac3347b61cb2c56f08fe8a8070d10bc5cbbbdb8bad4172c29a598f8a3edfab35"
    sha256 mojave:        "9643e7d0661f84cc4f790c26af86aba8f9cdffb3e03fc6d9f4c5baa54d637367"
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
