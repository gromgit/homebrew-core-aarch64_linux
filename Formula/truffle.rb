require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.4.6.tgz"
  sha256 "cc14176a572d7dd90c17545c70201e37db3d259b9cb0df7734557acad3c0c397"
  license "MIT"

  bottle do
    sha256 big_sur:  "e26e4a5e80777c71b06b126e090ee867b7c1f54552023335afe0592293fd9990"
    sha256 catalina: "0c8b46a8c4cd4dde2b54a6e68772c96ac65f86e079c2d7d33a2b4784f6d3756b"
    sha256 mojave:   "b3eec177b246fd768dd9d797cdf5a0ba3072dbd3f4f0183fe6f25fec7d1c7c01"
  end

  # the formula does not build any binaries for arm64
  # see upstream issue report, https://github.com/trufflesuite/truffle/issues/4266
  depends_on arch: :x86_64
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
