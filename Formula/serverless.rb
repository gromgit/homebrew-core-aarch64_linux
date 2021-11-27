require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.67.0.tar.gz"
  sha256 "2cde957256823f1b07fc96567cfae73ce40d5de2c1567415a662f7f251db05f5"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "84fd4cd26d3cdbb171e4c5b7d1d039e186aa1c65e2b59dbc012fa8d5b935b9ad"
    sha256                               arm64_big_sur:  "4d763fa9c4831b0b05e872140b8107458c437456e9965dca5ed07068b612e551"
    sha256                               monterey:       "bc21e58b148014f76c0e57c648f1716c5bac8a40ba66c7a4afdcd120f3d9ad83"
    sha256                               big_sur:        "a019408359dd8c488a73995513d482ecf95fbebc29736363b0e713fc053d7d33"
    sha256                               catalina:       "8b8555acabafd48e602181e44c11dd6fadc3a1613adfaf7aec9c0fddf21a6661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23abf10804c47ac98c3a23e70190d0464710095c9b7ce4af7f6a7230ef62bc01"
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
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
