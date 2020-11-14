require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.11.1.tar.gz"
  sha256 "36eddac2c3273bdbe3e8e92f41b0a244d0824d023624d94a979290c98a38681b"
  license "MIT"

  bottle do
    sha256 "d2c5cf11a28832cb5b45bac5456a0156c5d279af4487b3244b20077c95155936" => :big_sur
    sha256 "958fdeeac2a0c4ab592d0760f2ec234e6d6b30a2a071a6f4b7d24d4c68c13521" => :catalina
    sha256 "d44be90880db425ed036e3bb78df9aa45f50d57ad36ba1f5965c805f6cb24bb9" => :mojave
    sha256 "34f38fd6e770fdc77167f12ddc1c8a91dcb5b4a93c1b2b2acadb0fdc28700375" => :high_sierra
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
