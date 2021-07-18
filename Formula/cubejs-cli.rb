require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.0.tgz"
  sha256 "022d8f4a33c691173147b5bd01a1388220f8ab6053b8385f2afd20df68cea03a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66273526c230f9ce83f51b11aee83f703e0594b8b2ac401e5f63242dfb7f4cfb"
    sha256 cellar: :any_skip_relocation, big_sur:       "544e792bfdaa23eb47046f2fd1eb5f747e15d52d1d7c72843733b178978a895b"
    sha256 cellar: :any_skip_relocation, catalina:      "544e792bfdaa23eb47046f2fd1eb5f747e15d52d1d7c72843733b178978a895b"
    sha256 cellar: :any_skip_relocation, mojave:        "544e792bfdaa23eb47046f2fd1eb5f747e15d52d1d7c72843733b178978a895b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66273526c230f9ce83f51b11aee83f703e0594b8b2ac401e5f63242dfb7f4cfb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
