require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.50.tgz"
  sha256 "af0a48f7521ccde10e2f49db1c4bb9155530921a9a4cfdb9a774bdbabb5b12e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6528fee338c1e52bffe0c1fe4437543326e9eb46b453ddd3f6201833e0e27fed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6528fee338c1e52bffe0c1fe4437543326e9eb46b453ddd3f6201833e0e27fed"
    sha256 cellar: :any_skip_relocation, monterey:       "c754e272fafe0d13c2f0779101ef691f3dc52b27ea61288c7570032fa260696a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c754e272fafe0d13c2f0779101ef691f3dc52b27ea61288c7570032fa260696a"
    sha256 cellar: :any_skip_relocation, catalina:       "c754e272fafe0d13c2f0779101ef691f3dc52b27ea61288c7570032fa260696a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abe015cd3464f00b75cb5a1b0ca6ce3b25a92283cebbfc7fe3fa941ff13386ae"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"app.jsx").write <<~EOS
      import * as React from 'react'
      import * as Server from 'react-dom/server'

      let Greet = () => <h1>Hello, world!</h1>
      console.log(Server.renderToString(<Greet />))
    EOS

    system Formula["node"].libexec/"bin/npm", "install", "react", "react-dom"
    system bin/"esbuild", "app.jsx", "--bundle", "--outfile=out.js"

    assert_equal "<h1>Hello, world!</h1>\n", shell_output("node out.js")
  end
end
