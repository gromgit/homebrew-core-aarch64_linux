class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.54.6.tgz"
  sha256 "95334a742b5c6922cc6549069dd4583a80a713a0baf52f88ab8804bc9a594bbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0956648e8ec70b0f87689e11436787a57c29c97a7593cfbd2596647ddd9b2e69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0956648e8ec70b0f87689e11436787a57c29c97a7593cfbd2596647ddd9b2e69"
    sha256 cellar: :any_skip_relocation, monterey:       "0956648e8ec70b0f87689e11436787a57c29c97a7593cfbd2596647ddd9b2e69"
    sha256 cellar: :any_skip_relocation, big_sur:        "0956648e8ec70b0f87689e11436787a57c29c97a7593cfbd2596647ddd9b2e69"
    sha256 cellar: :any_skip_relocation, catalina:       "0956648e8ec70b0f87689e11436787a57c29c97a7593cfbd2596647ddd9b2e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "583cfaa692da7f51374d86cea51e72f9b4fc7dc67a38831ef949a916e20d86d8"
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
