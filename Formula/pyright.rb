require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.185.tgz"
  sha256 "2b1461ee10678ba053a49cab2b6e078b49b1100060af3dbf382ee7a775f99c80"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, catalina:       "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
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
