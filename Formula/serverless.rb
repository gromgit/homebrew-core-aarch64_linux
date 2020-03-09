require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.66.0.tar.gz"
  sha256 "ffbb7c4c780d5d8f688a55c1d0003516efaadc885bd62a0ef08ec47d0afc1a85"

  bottle do
    cellar :any_skip_relocation
    sha256 "14b3cba84445d2a597d4a31836a891913c340161bb6f26e3c340d7dbde2ce66d" => :catalina
    sha256 "63906c037e85d577b2808711ccc651914041cb4033259faa678f52aea257e6d0" => :mojave
    sha256 "af7135f00b500f9fa761039f3c997b89e0c8a46f785aa33d9157ea93f94e6fce" => :high_sierra
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

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
