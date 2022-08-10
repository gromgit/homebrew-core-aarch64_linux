require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.0.tgz"
  sha256 "a580f416a4437c3922dcab9c234b36cab1b3d385a53efb4d663972019c38ef60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f97f7cf544078ff748eb54119154045df833db5127097ab90063e87fe231c921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f97f7cf544078ff748eb54119154045df833db5127097ab90063e87fe231c921"
    sha256 cellar: :any_skip_relocation, monterey:       "69156bd33b88de343185a98273047a477b096af766cea9788b7e86d99d07d0df"
    sha256 cellar: :any_skip_relocation, big_sur:        "69156bd33b88de343185a98273047a477b096af766cea9788b7e86d99d07d0df"
    sha256 cellar: :any_skip_relocation, catalina:       "69156bd33b88de343185a98273047a477b096af766cea9788b7e86d99d07d0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a068b00060379894d3a6a106c03fe57a601a89f2c9cff693cd26b86b99625198"
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
