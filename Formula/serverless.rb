require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.39.0.tar.gz"
  sha256 "1c7fd9cb9c989d77a768e3b747fc9bf71820716707998acd6c4672cc0bf23361"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "ddea3d9387dbb33944d9c3d816c3957d35af8c678f47b35e8ff43d7f92757842"
    sha256 big_sur:       "2c38b879f4d777fe1f8a8d643612d7307fcd7f43f5a9502960e082305f605d0b"
    sha256 catalina:      "1e90ac4513f6103ce6c519541d3398f2f63bf76dc2680c0c2cb09d22ee537ee7"
    sha256 mojave:        "32748607463623cf9da9a18982089a43a4443972b2787334653fab68d0abfa79"
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
