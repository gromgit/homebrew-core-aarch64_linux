require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.7.tgz"
  sha256 "efdbe9156bae864fe7c9d909984f5c955d05e1ab18adce6d15cad1a0e8ff02af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0080b5b0dbf5bf4b738487e4adf6fcf8f804a7bfc0750404169a2190e054e7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c300f136208cb6f64d59826f3e5a386cc8a659e65f28dc79d00cfb7de59eb926"
    sha256 cellar: :any_skip_relocation, catalina:      "c300f136208cb6f64d59826f3e5a386cc8a659e65f28dc79d00cfb7de59eb926"
    sha256 cellar: :any_skip_relocation, mojave:        "c300f136208cb6f64d59826f3e5a386cc8a659e65f28dc79d00cfb7de59eb926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebe7fc98eab766df3bfa73a8bece8424df9fb006a0bbf8e7962c19ca01524e71"
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
