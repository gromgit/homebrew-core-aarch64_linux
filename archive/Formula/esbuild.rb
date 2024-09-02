require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.38.tgz"
  sha256 "8f2b2f038089c81eb2f52b1b6062b1b39cb7b93ed962069f4d3c70c899857b5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d961e4f81d6e7e0035284f8ae046d591bad40f9099eefe5242f2a4d56b0d79a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d961e4f81d6e7e0035284f8ae046d591bad40f9099eefe5242f2a4d56b0d79a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f2ef4cb1eea0188415cdc74b2a1958fc5eded75f4815ed105b0cc4fb71696439"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2ef4cb1eea0188415cdc74b2a1958fc5eded75f4815ed105b0cc4fb71696439"
    sha256 cellar: :any_skip_relocation, catalina:       "f2ef4cb1eea0188415cdc74b2a1958fc5eded75f4815ed105b0cc4fb71696439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "911bd3ebcc3583959f9971d0ccdeb5ba8ec8392517965757db47885ac04efa15"
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
