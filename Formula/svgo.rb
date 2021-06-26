require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v2.3.1.tar.gz"
  sha256 "a88c0a0f733f39f673938f75e8ae3ee25a04fa5a601a50aa00a8573c8ca84e98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa21d84ddda6f26c44fd030631059cd8175cdfd85fff8f821d33a0abe3e9846f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
