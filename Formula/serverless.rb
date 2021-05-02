require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.39.0.tar.gz"
  sha256 "1c7fd9cb9c989d77a768e3b747fc9bf71820716707998acd6c4672cc0bf23361"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "6492c3c496584d24d1391559dd7bdd796df706798f575cde8704165b67b2e3cf"
    sha256 big_sur:       "02cdace553a025566f85e12ceb12b51177e99ae446f8b2a88b3992a8c156380c"
    sha256 catalina:      "0a1c057093c0a86e479dcef1d643d4524ae56edbd26b6a922a7957908a8309b3"
    sha256 mojave:        "5358ed69db61a2db8944ccc4917a040badf9803f6b32c541ecd512731c2ee024"
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
