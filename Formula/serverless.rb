require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.11.0.tar.gz"
  sha256 "5e6399f992d4aaa1fb928c10db73a1e614e23e9aa351dc2a45fd8e731928a396"
  license "MIT"

  bottle do
    sha256 "5ce2fae1477fd101f6b1afd4e7a4e53ac3bc66e90be24101e348b30aaca9e849" => :catalina
    sha256 "9dc54e54f5f609f2f686d13dee8bd4928c2320fb5c8b524b8d2bbc067502f693" => :mojave
    sha256 "78b1e2f837045cda0bc81210171c22a8c3e7197d68fb40412df2205624178e72" => :high_sierra
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
