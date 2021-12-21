class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.45.1.tgz"
  sha256 "88c260312b2497e7ac7ce96f8d1caf47f3164ef3895f6183456f12a5f59ffda1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee786281ebc79ad1b58c19d2b8f82238f2909e3b1ed24eb8c9f24833b14f9b25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee786281ebc79ad1b58c19d2b8f82238f2909e3b1ed24eb8c9f24833b14f9b25"
    sha256 cellar: :any_skip_relocation, monterey:       "ee786281ebc79ad1b58c19d2b8f82238f2909e3b1ed24eb8c9f24833b14f9b25"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee786281ebc79ad1b58c19d2b8f82238f2909e3b1ed24eb8c9f24833b14f9b25"
    sha256 cellar: :any_skip_relocation, catalina:       "ee786281ebc79ad1b58c19d2b8f82238f2909e3b1ed24eb8c9f24833b14f9b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fdf744eb03df449bb28948f93e5ed85b3a78250fc1efdfef4763ecd5415f41"
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
