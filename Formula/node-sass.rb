class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.34.0.tgz"
  sha256 "970f1c7847f512f00776be900b548a26c4f243c51bbe0e0c27a5c5ec28c60f56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14640fbe387a573a7f7fd270b8faf2cd79c7f3ca46949cfcef0c87b7e809bb14"
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
