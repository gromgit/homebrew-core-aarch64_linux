require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.241.tgz"
  sha256 "7923565bd09a92a418a4c9c4b57e8523ffeec1a9fa1da5583062dd9dfc333ec7"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4783390b22136af1c0e818d02495dc8cfd1b1abf88adba96b80fa5ed87d48f8a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end
