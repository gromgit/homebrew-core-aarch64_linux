require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.7.tgz"
  sha256 "b363c871f0c16a1fb6695f223dcc433f2f173885e6fe5adde51572f5276967ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f61831a7df480586b5b2251f956f9259bd88980d59049e870f790f78bf7cd90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f61831a7df480586b5b2251f956f9259bd88980d59049e870f790f78bf7cd90"
    sha256 cellar: :any_skip_relocation, monterey:       "7005c9092fd674920b7cfbccf901322fd590dcb392375ee2806ec50c031eaab0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7005c9092fd674920b7cfbccf901322fd590dcb392375ee2806ec50c031eaab0"
    sha256 cellar: :any_skip_relocation, catalina:       "7005c9092fd674920b7cfbccf901322fd590dcb392375ee2806ec50c031eaab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98cf64994f4401ac67d7f1af2ff792380a1155466e746dfc5dbd316f28e857e"
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
