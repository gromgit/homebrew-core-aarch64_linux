require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.82.0.tar.gz"
  sha256 "f5a78a3bf4401f6c048270c3a287a7737eb431f4225b8a0da163fe8db5b48205"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "717635c76dc73b73b47158aea7be5776d7f2e038f19f3ef05d7b37ce01bafcd4" => :catalina
    sha256 "ad0c946cc898b6eed854a253026fe807d0150a963680c2d54211fc9bbc0ab950" => :mojave
    sha256 "434043fbe444c2eb379bcf88b3cf1f401d7d135640d8a47d82ba5896457b3242" => :high_sierra
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
