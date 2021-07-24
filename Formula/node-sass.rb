class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.36.0.tgz"
  sha256 "316fde0353ced2fee300472d6c98ec148613261bb3ffe27dcfd4b1fb5112e2b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90532d87d916457278e7fc427a0b9a57d648326d0ebc1d40252e5f244476e419"
    sha256 cellar: :any_skip_relocation, big_sur:       "90532d87d916457278e7fc427a0b9a57d648326d0ebc1d40252e5f244476e419"
    sha256 cellar: :any_skip_relocation, catalina:      "90532d87d916457278e7fc427a0b9a57d648326d0ebc1d40252e5f244476e419"
    sha256 cellar: :any_skip_relocation, mojave:        "90532d87d916457278e7fc427a0b9a57d648326d0ebc1d40252e5f244476e419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1af28f19c2171e8090399f3afd5c8cb743913221be58f308867e8707e579817e"
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
