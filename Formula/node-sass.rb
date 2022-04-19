class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.50.1.tgz"
  sha256 "28ca5f417e9dd705738127839f16c07d826aa2704d16427dd2b106a3e9922453"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8c53e837865df057abd58d9d1111c1cc686976a3ad3fae5a7e97783d4b3cf18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8c53e837865df057abd58d9d1111c1cc686976a3ad3fae5a7e97783d4b3cf18"
    sha256 cellar: :any_skip_relocation, monterey:       "b8c53e837865df057abd58d9d1111c1cc686976a3ad3fae5a7e97783d4b3cf18"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8c53e837865df057abd58d9d1111c1cc686976a3ad3fae5a7e97783d4b3cf18"
    sha256 cellar: :any_skip_relocation, catalina:       "b8c53e837865df057abd58d9d1111c1cc686976a3ad3fae5a7e97783d4b3cf18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59478da35e64789a1419d21f09292c789e8afd1deb020289c8fd6cdbd492bb0"
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
