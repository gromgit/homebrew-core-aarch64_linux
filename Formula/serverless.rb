require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.13.0.tar.gz"
  sha256 "13872716ed938f87ba3d87e97c85d899f2d51a0d7ff8a37673e6dbbb00db2078"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff9031359b9a9f49bc507c0e30468569cd9291c09e57b39f77f53f32949a7ba4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff9031359b9a9f49bc507c0e30468569cd9291c09e57b39f77f53f32949a7ba4"
    sha256 cellar: :any_skip_relocation, monterey:       "9520cd93f69bf3b962764f4df5b575142d45699f7088c6499a125acf09450b6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9520cd93f69bf3b962764f4df5b575142d45699f7088c6499a125acf09450b6c"
    sha256 cellar: :any_skip_relocation, catalina:       "9520cd93f69bf3b962764f4df5b575142d45699f7088c6499a125acf09450b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb09f9a79e0ed9d57060aa63cc430cd924361534700d5664e39c3db795c5e72"
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
