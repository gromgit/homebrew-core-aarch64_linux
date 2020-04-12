class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.3.tgz"
  sha256 "d346a5b9b02680b4cd2440346ec3ff099d3c7d738524620196601915bc57992a"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ba085dcc62cb91702417b58def55fd078d5dd163bf9c36ae5a43c50ff3926e2" => :catalina
    sha256 "ebf8da63edcd9e91298d01320f69f678790340deb7b6c3ea022871c3f69cc821" => :mojave
    sha256 "15ad9db7d0701ace285406c1b2c037a4ea6776059e155b049f999a4de7fb573c" => :high_sierra
  end

  depends_on "node"

  # waiting for pull request at #47438
  # conflicts_with "dart-sass", :because => "both install a `sass` binary"

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
