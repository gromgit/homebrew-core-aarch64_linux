class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.54.1.tgz"
  sha256 "9aea5cbae3bdda7a970eebfa854fd92aba8a20ac25d2f71b255737944d9cddd7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219560b119c232d71da77195cbf678ea0112e74317fe12facfb56d6eda817fb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "219560b119c232d71da77195cbf678ea0112e74317fe12facfb56d6eda817fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "219560b119c232d71da77195cbf678ea0112e74317fe12facfb56d6eda817fb4"
    sha256 cellar: :any_skip_relocation, big_sur:        "219560b119c232d71da77195cbf678ea0112e74317fe12facfb56d6eda817fb4"
    sha256 cellar: :any_skip_relocation, catalina:       "219560b119c232d71da77195cbf678ea0112e74317fe12facfb56d6eda817fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8659b18dc07add42e35787e75889290f4e8e53e9552b2526c8c8eb9277647da2"
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
