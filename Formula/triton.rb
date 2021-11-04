require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.15.1.tgz"
  sha256 "e325641d2ba183c484597e196ee74ecf67e6a0bcb459dd7ef49d23c509eec984"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b7a8608059c99cf8107c068151dd548aac3d15dd1f986f5786070980959d2a0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "85d3dcacfcbfbdeea29c5fa480f4c9300f3571fde69a8267d9c52549a4c4784a"
    sha256 cellar: :any_skip_relocation, catalina:      "4e983929a1d92eb733d8bba821fb99caa3aa03dabc28df7965d4b8f307462411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5fe6ca92a17edbeb1e1868ad99c9ce19db6110c188fc244a3746437d9518a7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end
