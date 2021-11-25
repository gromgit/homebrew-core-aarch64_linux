class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.43.5.tgz"
  sha256 "e41dc45699c3c2ef9e029190defa4c131614a0ad109640bddb760199fea81e2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3492b985eaf5a1f8aa5c15c187c1a78fd4d7f9788cdb0e04e922fdb414f3ce87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3492b985eaf5a1f8aa5c15c187c1a78fd4d7f9788cdb0e04e922fdb414f3ce87"
    sha256 cellar: :any_skip_relocation, monterey:       "3492b985eaf5a1f8aa5c15c187c1a78fd4d7f9788cdb0e04e922fdb414f3ce87"
    sha256 cellar: :any_skip_relocation, big_sur:        "3492b985eaf5a1f8aa5c15c187c1a78fd4d7f9788cdb0e04e922fdb414f3ce87"
    sha256 cellar: :any_skip_relocation, catalina:       "3492b985eaf5a1f8aa5c15c187c1a78fd4d7f9788cdb0e04e922fdb414f3ce87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24d122731daebf7d26fc89d3b036fa8417384e094927ef09c26c2cc96b3c2f96"
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
