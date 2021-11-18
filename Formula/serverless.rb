require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.66.2.tar.gz"
  sha256 "7276237fbaf3c1ef101845d800d3fb0116d9d50b7243ad68e18d5d7c577623dc"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "master"

  bottle do
    sha256                               arm64_monterey: "4eda3715aeb1152e9f487cc3dd8e8948895af23b217e47df0f02e200f5cf64ce"
    sha256                               arm64_big_sur:  "8e898db4209b9779a527664eb14299bf79f5894330df0358a38f25fbc2abc930"
    sha256                               monterey:       "e50b6db6ed0c1269e1fc69ee68b135caa3089803488204d8c970f5a59304aa4a"
    sha256                               big_sur:        "5f1bd3124e60a7af3aec769ac03d096a6a893843c2f1a930bacce77c08fb0dbe"
    sha256                               catalina:       "c60b085ef9211aec845d2ff20f71df96ada459ddaa25a19113cb7b92e9d1087d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c993f99f1944e0dd824350d148372158838071ba6696261039eb2c3e043cba"
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
