require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.6.0.tar.gz"
  sha256 "661f996829efa5b1776291c046182718804f37b20f019752cce9ec59c98bf49f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "134ac9349df97d1b73ce06470c45b5459ce8d7be3b34cf014c0fe42daf78410e" => :catalina
    sha256 "d8d50c12507ffb3c824274f31bc2fae1b48b2daca536a7044b4a8ddadf14911f" => :mojave
    sha256 "f02789b03c588186af0f7c1dd9f8c024587743f562c7b3c4e487b5f730b07c33" => :high_sierra
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
