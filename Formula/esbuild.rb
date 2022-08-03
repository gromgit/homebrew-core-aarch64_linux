require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.53.tgz"
  sha256 "24907e776463af5288a6e4fd1cbb6dd0a7145d03817ddf3bb2adff8095aa4ec7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3be6a2bcd5335f688e679bbdc7db5b7af6fd5aaa43dcbd85506f7b53711e07d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3be6a2bcd5335f688e679bbdc7db5b7af6fd5aaa43dcbd85506f7b53711e07d8"
    sha256 cellar: :any_skip_relocation, monterey:       "d55b4d17ec28bfe5f9c9e968b4970085056bea37b94dd3a1a628c99fbc109df2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d55b4d17ec28bfe5f9c9e968b4970085056bea37b94dd3a1a628c99fbc109df2"
    sha256 cellar: :any_skip_relocation, catalina:       "d55b4d17ec28bfe5f9c9e968b4970085056bea37b94dd3a1a628c99fbc109df2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d2a23bface710cd1445c04d4cbbdb5a369c8b8417e58208997b3eb4d8b0ed99"
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
