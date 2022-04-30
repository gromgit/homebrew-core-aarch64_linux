require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.16.0.tar.gz"
  sha256 "c7ca86b1c3690fb2c54a4a26ede07fd56c5d0acdb233c9877e714249daad2680"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9395569e29fdf39ec1b3093fcba693f90b646fd136b86ef1306a21782874816"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9395569e29fdf39ec1b3093fcba693f90b646fd136b86ef1306a21782874816"
    sha256 cellar: :any_skip_relocation, monterey:       "05808952f2b311556f0d6414091b714d1c784eeb8dbcb2b6ee5df51b90323b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "05808952f2b311556f0d6414091b714d1c784eeb8dbcb2b6ee5df51b90323b4c"
    sha256 cellar: :any_skip_relocation, catalina:       "05808952f2b311556f0d6414091b714d1c784eeb8dbcb2b6ee5df51b90323b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "532c9fd08dfd01a48f9da95c2a3ba5f9b7acfb386b32a84f769e3a63e6c7ea09"
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
