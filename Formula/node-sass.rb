class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.34.1.tgz"
  sha256 "218aeaa96b25092757bcc55615825e1ba58d038e0734c579f9cf066b6debe291"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5388359beacfcac8c3489548281f180d9140f1477e3e996bce3336dd66de1f44"
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
