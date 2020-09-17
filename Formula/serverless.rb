require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.1.1.tar.gz"
  sha256 "4043faf610d6c6567f6ca822d294d1bb19e514721f4446a8b6d222901d6857da"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "038134c2f00f12df74308bbe8b690b5b5e9e474e0729626ac9781a23caa13c39" => :catalina
    sha256 "75c0932fd4928a67c6a5f7dc9769c6ea9208102c1264a1016a0572d5c5f33e6e" => :mojave
    sha256 "6294ee42923d71a6835722b2d05cb40f948c891d457e8d00f4f8e767cc08b206" => :high_sierra
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
