require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.24.0.tgz"
  sha256 "fbc6bf1fdbf900b37ac3ca49a7a930f2882cc7f8b136481f2fe6dd71a0a8a4b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "369a35825cd6fbee61ab0e729a58320caf34f669c19012cb9f786f29a5ef0fdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "369a35825cd6fbee61ab0e729a58320caf34f669c19012cb9f786f29a5ef0fdf"
    sha256 cellar: :any_skip_relocation, monterey:       "ed229d320429ea4411661c37947ea485feaf76b3630dcc157a0d0d0a4fb8554b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed229d320429ea4411661c37947ea485feaf76b3630dcc157a0d0d0a4fb8554b"
    sha256 cellar: :any_skip_relocation, catalina:       "ed229d320429ea4411661c37947ea485feaf76b3630dcc157a0d0d0a4fb8554b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369a35825cd6fbee61ab0e729a58320caf34f669c19012cb9f786f29a5ef0fdf"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
