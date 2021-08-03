class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.37.2.tgz"
  sha256 "76fd2d360fbef78dc81986dc5d193fac31e21deb6bd05dc8f5cb53250b0b0d4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a944cdc9cd8faf79bbbe79ec1c3ea31a626129baa1d70660d0d8aab07b1c3ee8"
    sha256 cellar: :any_skip_relocation, big_sur:       "a944cdc9cd8faf79bbbe79ec1c3ea31a626129baa1d70660d0d8aab07b1c3ee8"
    sha256 cellar: :any_skip_relocation, catalina:      "a944cdc9cd8faf79bbbe79ec1c3ea31a626129baa1d70660d0d8aab07b1c3ee8"
    sha256 cellar: :any_skip_relocation, mojave:        "a944cdc9cd8faf79bbbe79ec1c3ea31a626129baa1d70660d0d8aab07b1c3ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2ca177f6f374faf3bc8737ac56e6ba58d77bcfd0a6149e77169cf4b490b4d4"
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
