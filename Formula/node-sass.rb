class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.37.4.tgz"
  sha256 "e19ba8cfa6d5be088086ca79e22867d4ef5026033134da3a4c99de064bc82530"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "06c082e66b492a3dc5080653860e888bb4eda388b141fe058c8019adc9b44c51"
    sha256 cellar: :any_skip_relocation, big_sur:       "06c082e66b492a3dc5080653860e888bb4eda388b141fe058c8019adc9b44c51"
    sha256 cellar: :any_skip_relocation, catalina:      "06c082e66b492a3dc5080653860e888bb4eda388b141fe058c8019adc9b44c51"
    sha256 cellar: :any_skip_relocation, mojave:        "06c082e66b492a3dc5080653860e888bb4eda388b141fe058c8019adc9b44c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51d4ab76a30cd5c54772e34c8a6928f371912e58cb2d21fda654820a19668a7a"
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
