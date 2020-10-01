require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.4.0.tar.gz"
  sha256 "4ef2f5d3c643b04c8094d4de2b1bbfb815acd07f8a91743495dc42cd7a5d4c1a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fb9b3d69e1296fd9d856f514d61f7305c7dfdbe685f62969b945ae28c96e648" => :catalina
    sha256 "1bbb2f68f205f53175cdb4d36b5b66bfd24163de8508c4d34506e28aa14048e6" => :mojave
    sha256 "e1d8bccac85151c5f7328f4b8a93a56fbfe57746974bf7380fe4aed68e20601e" => :high_sierra
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
