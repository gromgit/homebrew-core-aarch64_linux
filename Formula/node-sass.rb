class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.39.0.tgz"
  sha256 "ecf39d2b8e938c451efead3043b6eec4e321f5199d558db334a29ecc10730af3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f115bc336a7a81dd3f65ede00af443423b8f9373229f4d5b089523d98e3e1a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f115bc336a7a81dd3f65ede00af443423b8f9373229f4d5b089523d98e3e1a7"
    sha256 cellar: :any_skip_relocation, catalina:      "2f115bc336a7a81dd3f65ede00af443423b8f9373229f4d5b089523d98e3e1a7"
    sha256 cellar: :any_skip_relocation, mojave:        "2f115bc336a7a81dd3f65ede00af443423b8f9373229f4d5b089523d98e3e1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "867f4cf7e03b5be73d087a7b4c2a8a00b8cbee558c3e83588114be90e1934fbf"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
