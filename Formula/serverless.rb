require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v1.77.0.tar.gz"
  sha256 "47db016b3f26b1e79cd27d5b80d5a50176831c0fab9141df80064e6977a6273b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d913c7d951fa9a7c2d1d7d7fba8b15d1e8473a09bd7542240fbe4ac762812b72" => :catalina
    sha256 "7dc846268b5714f31768e89eff8b1f9db6cd9bc4e5ebb53dd9ff09c283edb9cf" => :mojave
    sha256 "032804f3834ed097fee0bf834e0d7706553c3653e4eb6589d5cc268c48fdced6" => :high_sierra
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
