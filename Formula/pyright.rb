require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.158.tgz"
  sha256 "9f5ffc52bb542ff21772f2a0b738c193984e39ff91b392bd4186f6ba7dc6d51c"
  license "MIT"
  head "https://github.com/microsoft/pyright.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98cfc39d1063e138086a04ad0742947930d52ab5100849cefb2189e03052a398"
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
