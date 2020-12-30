class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.0.tgz"
  sha256 "10cf6e249025883c917cba6a0cf95fe24783904818654ffd606b63a590443f16"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3714e2c97c541989ff1effcb7905ade5c5bd5ad7b173febaa214318936c85d51" => :big_sur
    sha256 "e6c49ff4689fd4ab33dcd82bd2660a345f99da0c9a324baba650649a00d33e3d" => :arm64_big_sur
    sha256 "5b4c626725475373df76a9d00dd618fb21d165300bd75aed143c8f6b416f8e0f" => :catalina
    sha256 "da49b7102e6d2c3691ad6d9e8ccc6d324ea7a6166d82338df832c5b673cf0eb5" => :mojave
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
