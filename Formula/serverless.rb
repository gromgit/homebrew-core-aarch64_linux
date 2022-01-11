require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.71.0.tar.gz"
  sha256 "91486d996029f3e5f7871521cab23b3f33a1685ac8ceaf11cfddae6939a14475"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "82e597f4183bc04a1bd58b91699128cdd1c69228348aa984c66062d3c4c8abb3"
    sha256                               arm64_big_sur:  "a50b0d096b137b7685bedb6fa3f149a22f444cd5d9f544de3a0ec1495b60720b"
    sha256                               monterey:       "62f64a16f605cd21aeddb8df01572bfe1618c8bcacc329386166aae71a489d85"
    sha256                               big_sur:        "de1130e5a1af42dd9055da57e49b5fadb5d2ea9d42540c105ded4d6faebae0cb"
    sha256                               catalina:       "e865f783670f05430ff346d99de926676a63e70a951c69c3b20671062d6dbdf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e3a1e9d43d34bd5455b0c9b415964875995dfa31419ca01e263f377e9c3cb27"
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
