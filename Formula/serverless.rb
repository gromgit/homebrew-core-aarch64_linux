require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.15.0.tar.gz"
  sha256 "e8781f43611ffdd0b00a497b37f7267b38e72fe46570dd02a15c3534fef6cc8a"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04ff70761c923aeea7f02b04b5e4d1a5ad128f8d4f9f00ccf5d4b512b3506803"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04ff70761c923aeea7f02b04b5e4d1a5ad128f8d4f9f00ccf5d4b512b3506803"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd27d2dc755927899b45191e944091cdf027dae05dad716037ac2bc2cbb7c9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dd27d2dc755927899b45191e944091cdf027dae05dad716037ac2bc2cbb7c9e"
    sha256 cellar: :any_skip_relocation, catalina:       "4dd27d2dc755927899b45191e944091cdf027dae05dad716037ac2bc2cbb7c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "306571d305c1e3eea493108cb1fbd22fa2727e9549f74af672ae5952ce05a31c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Delete incompatible Linux CPython shared library included in dependency package.
    # Raise an error if no longer found so that the unused logic can be removed.
    (libexec/"lib/node_modules/serverless/node_modules/@serverless/dashboard-plugin")
      .glob("sdk-py/serverless_sdk/vendor/wrapt/_wrappers.cpython-*-linux-gnu.so")
      .map(&:unlink)
      .empty? && raise("Unable to find wrapt shared library to delete.")
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
    output = shell_output("#{bin}/serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end
