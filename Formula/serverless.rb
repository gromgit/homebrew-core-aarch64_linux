require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.18.0.tar.gz"
  sha256 "9670d9c8cb6bac1c89b1dfdb08c1a36e8a45ba3e3def305f9112fae5771d6c8f"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b239ae4b2c9bb557028aaa300513507352d9b28cd9de806c3a671f8b2d333197"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b239ae4b2c9bb557028aaa300513507352d9b28cd9de806c3a671f8b2d333197"
    sha256 cellar: :any_skip_relocation, monterey:       "a94bb90826c6108fbcc7be600cfb19ed4d94859fa2603bb9764ef1e77d7225b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a94bb90826c6108fbcc7be600cfb19ed4d94859fa2603bb9764ef1e77d7225b9"
    sha256 cellar: :any_skip_relocation, catalina:       "a94bb90826c6108fbcc7be600cfb19ed4d94859fa2603bb9764ef1e77d7225b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f791547c5b5a0a76f1526b18485ba76d51570f06ab96eefda4d4d4d782613fa3"
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
