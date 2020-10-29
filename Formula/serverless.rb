require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.9.0.tar.gz"
  sha256 "dc8c2aafee8e8e866232f24748e32ff6472d3c774f8c1f663960c4ae07156d88"
  license "MIT"

  bottle do
    sha256 "d0a2812612ff86e3eb505c255d45edf391b238dd0575f294443e26976cf0ba67" => :catalina
    sha256 "ec445a8f8c4fa800f099ae8b69e64bae806bf9c39954e42f9db2a697033dc124" => :mojave
    sha256 "f1f5621d8becf57cff102a0d7cf5ca995adf77f93d209cd02684fa9687d31799" => :high_sierra
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
