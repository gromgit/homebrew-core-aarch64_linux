require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.15.0.tar.gz"
  sha256 "e8781f43611ffdd0b00a497b37f7267b38e72fe46570dd02a15c3534fef6cc8a"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cb6237e4f98d8ef286349eda4f14e542012a8bce3aaf3ca4329527a10381440"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cb6237e4f98d8ef286349eda4f14e542012a8bce3aaf3ca4329527a10381440"
    sha256 cellar: :any_skip_relocation, monterey:       "722b61eb39f302b3621b4cd8ce761c9b9b2df7d1aba48835eaa1711f54c4c998"
    sha256 cellar: :any_skip_relocation, big_sur:        "722b61eb39f302b3621b4cd8ce761c9b9b2df7d1aba48835eaa1711f54c4c998"
    sha256 cellar: :any_skip_relocation, catalina:       "722b61eb39f302b3621b4cd8ce761c9b9b2df7d1aba48835eaa1711f54c4c998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7936d7306ca707c8d66e173b1b94118e75d608ff8613ac3442b55ce1d96fc3b8"
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
