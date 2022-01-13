class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.48.0.tgz"
  sha256 "c7d3de04598166fe3842cf57b358d49a4a36a999929ca6ac1602419c7620291a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b36b30001c5058a17ec030901d458b5dd2b089c9dc41e659003b58204fe262"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7b36b30001c5058a17ec030901d458b5dd2b089c9dc41e659003b58204fe262"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b36b30001c5058a17ec030901d458b5dd2b089c9dc41e659003b58204fe262"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7b36b30001c5058a17ec030901d458b5dd2b089c9dc41e659003b58204fe262"
    sha256 cellar: :any_skip_relocation, catalina:       "f7b36b30001c5058a17ec030901d458b5dd2b089c9dc41e659003b58204fe262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f61828ccb22133f91a868b13125ebc4865a1d1cec5e4cdac12757b5574a8ad2e"
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
