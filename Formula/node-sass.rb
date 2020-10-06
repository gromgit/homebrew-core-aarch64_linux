class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.12.tgz"
  sha256 "954ad376eee274ca65e78e281151809e4e605cd081ffb64e9bd8fee6e8fbb85b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "be08c87ba8b6c076f7301df843f5dac56e026d20163160e86c0b475d749b06a6" => :catalina
    sha256 "3e35cded55a71399541d045d35a950a12d31913cd47923a7cb53bd3b5f39e52f" => :mojave
    sha256 "0d9347340a1012275ca3047105265182a044ad8ecb34b6db7740254a02d1b295" => :high_sierra
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
