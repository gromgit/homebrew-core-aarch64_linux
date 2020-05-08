require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.70.0.tar.gz"
  sha256 "95a0e21a8a60195ccf803c8cbe9f6b8de71938e395f592caacf352c4b7e55834"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d782b374d05ba85927b9414fad77e8725cabb2a8a20cf1e2e11e9b67b94f73e" => :catalina
    sha256 "71b8aa9e22993392b1776c6d49f1b92e83ce09199ef55fb6494a2c377cd39eb6" => :mojave
    sha256 "28fd92e60efb1d2b5c3e316b8ba8a3514fe39297721de4bd35783496151604f2" => :high_sierra
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
