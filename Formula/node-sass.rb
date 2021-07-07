class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.35.2.tgz"
  sha256 "65079d140b31e7834fe8856f1915ce32da3729beac13ab8b8750167024e1b012"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a092fc458b3c6759fd3a5f140e6d9e9e732cce3c0c4f658a0057f520854ea06c"
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
