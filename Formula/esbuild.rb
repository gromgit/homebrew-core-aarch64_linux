require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.5.tgz"
  sha256 "c2eb414231ba94ac6458b89dc264cb702f07864f59a09e8258836c61506ed9f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b8977979cd09e8f1c593539a6c2b222e25272f5738447789c01c747afeed9fb6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7fd0b54b9bfae6e48a55972797c54e1acafc014412b701ac30bb39c2e65a283"
    sha256 cellar: :any_skip_relocation, catalina:      "e7fd0b54b9bfae6e48a55972797c54e1acafc014412b701ac30bb39c2e65a283"
    sha256 cellar: :any_skip_relocation, mojave:        "e7fd0b54b9bfae6e48a55972797c54e1acafc014412b701ac30bb39c2e65a283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83979c8f37cfedd689a781af293f80c0475749428b1fbff2ccd17a1287047d0"
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

    assert_equal "<h1 data-reactroot=\"\">Hello, world!</h1>\n", shell_output("node out.js")
  end
end
