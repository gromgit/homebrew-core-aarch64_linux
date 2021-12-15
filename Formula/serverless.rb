require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.69.1.tar.gz"
  sha256 "bf577f2b4cf3495964884c0598f10e09beda57e092756ed1cc76862dc5c0ada0"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "4cef30cddf126a7a65f4fd7949ab6c5755735041a6040792f14b66d707570808"
    sha256                               arm64_big_sur:  "50b4743743cbe69826fd0b1711e2892847225eed1f02d51710f68e34f49b60ff"
    sha256                               monterey:       "7c569b6a4573c6862ba0cf953e9a8569073624076dbba82919436a9945e218ba"
    sha256                               big_sur:        "401f8637cd7f4c175df15c657b54874de020e1e830b75b2087c3f9350655c40f"
    sha256                               catalina:       "564a29589e81277b3427b79723a2c83de56d531cc86a7e1a6df2d02e65f057db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53b8ca1bbefb390ee4eee0e7a135a195e6d1fbec176c8f56455e999cc847701b"
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
