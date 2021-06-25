require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.12.tgz"
  sha256 "89a8cbfed670a8ac6494ab58d21680a83b87285aaba1c60ea910389acf6754cb"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "6a12782499b48463adbd2f719c2ccfa3590d1b24c7164c09976e8ab511d4a8b9"
    sha256 big_sur:       "9fe45f0eae2313317c4630b52c492c22d691164c55fba34f94b12c1c732faa64"
    sha256 catalina:      "d74017548740fede067c7f89bf0656442d84b9ab17826606369d2c42c033ad62"
    sha256 mojave:        "72b8f090cfffa7d1537d55f20bb053d99d19deace900605c04a571b93159748c"
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
