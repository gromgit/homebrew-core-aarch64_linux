class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.38.2.tgz"
  sha256 "48697096360975fdbf53fb4e6fc3173d7f2616e8f75d4467eac40939a0a67433"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64b63257353313e60b1c8d90e5f79de42cab062c6ea7ed49ddeadcd95a708987"
    sha256 cellar: :any_skip_relocation, big_sur:       "64b63257353313e60b1c8d90e5f79de42cab062c6ea7ed49ddeadcd95a708987"
    sha256 cellar: :any_skip_relocation, catalina:      "64b63257353313e60b1c8d90e5f79de42cab062c6ea7ed49ddeadcd95a708987"
    sha256 cellar: :any_skip_relocation, mojave:        "64b63257353313e60b1c8d90e5f79de42cab062c6ea7ed49ddeadcd95a708987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fa1926ca9a3e7b889a6647cab5733c9bbb7919bafe6a1edd5bc15d82b3bdd46"
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
