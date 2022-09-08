class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.54.9.tgz"
  sha256 "711e7d529462d5eb5d5ee0ab4b5424ef91dbd1a3a52fff42e9a11d49908b4331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff13fbc04a13fd23445c9fe441e68bf3e5cce10197e8b459b633844704c388f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ff13fbc04a13fd23445c9fe441e68bf3e5cce10197e8b459b633844704c388f"
    sha256 cellar: :any_skip_relocation, monterey:       "4ff13fbc04a13fd23445c9fe441e68bf3e5cce10197e8b459b633844704c388f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ff13fbc04a13fd23445c9fe441e68bf3e5cce10197e8b459b633844704c388f"
    sha256 cellar: :any_skip_relocation, catalina:       "4ff13fbc04a13fd23445c9fe441e68bf3e5cce10197e8b459b633844704c388f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b750be955fb3aab7c3455baa9e588f4fb340b6d00c18563af9b1d53505fb464a"
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
