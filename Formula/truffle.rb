require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.2.2.tgz"
  sha256 "f3be4bf340d9eb2be6b02e1a24f4fb4b99a41e8ad453bd36aee9070a96ca3adb"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "6950a6f225cbde212a7cde943a7401d11caf0dffdfd3bb625796b242f7a7354e"
    sha256 big_sur:       "92162dc8c309686c10d34f0bf46c67437e932af50cc3191d17c0e2dd874e968a"
    sha256 catalina:      "b4016765f7760d39d975590c94d4aea6730b56a9f58b07019918f79bfbf1ccb9"
    sha256 mojave:        "f9e79cf92eb3174306de50ce0d8ec25764886fad5c6fc547f6a6e907dbff71e1"
  end

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
