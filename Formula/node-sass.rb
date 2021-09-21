class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.42.0.tgz"
  sha256 "48f585c6e6d04a5f4ae98080fa1847e7c408b49b034fc51811f8b7bc9c5a958c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e850f135ebfb9fe03fd3f0eeaebad2a00c943b4ee36651dc93189ec0b9317bf6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e850f135ebfb9fe03fd3f0eeaebad2a00c943b4ee36651dc93189ec0b9317bf6"
    sha256 cellar: :any_skip_relocation, catalina:      "e850f135ebfb9fe03fd3f0eeaebad2a00c943b4ee36651dc93189ec0b9317bf6"
    sha256 cellar: :any_skip_relocation, mojave:        "e850f135ebfb9fe03fd3f0eeaebad2a00c943b4ee36651dc93189ec0b9317bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47a4273959a3591ea7343d9164d25efa35316e80e95cc08ffbca6807d21b7359"
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
