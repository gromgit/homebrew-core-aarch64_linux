require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.52.0.tar.gz"
  sha256 "bdb7653a0d2db7129cf99700b9c9e51365dd63107b39b5a784803473764d48bf"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "9434c348c47893589f3e63563f1409355c9e7689d35a3d9f288375b05953d50b"
    sha256 big_sur:       "96bce13b0e1a7168716334305e0ad9d12ede6513fc71730c8108574750910005"
    sha256 catalina:      "c5f89efb6f01d01a531b620cb8d85b6249630c52edc5fcb570555d1d97e72e42"
    sha256 mojave:        "2019609524bf908ef902728d13cdff3402becce2dc435376b09b735c8d645132"
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
