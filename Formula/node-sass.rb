class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.35.0.tgz"
  sha256 "8b56ee215b6d111adacdde9a5acf10d29ef80b2b835c429dc72c3705c4ea43fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a0ff50e9fb94cab1203656a53a2ae8df19c531c9f780db6f2b9821de88a8f6a"
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
