require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.6.tgz"
  sha256 "24a63ee9b6dabf51c91d42ab7cd2bf501e3954888974ddedfaa8face209980fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b77d6e39cdb2e4d34ea44d579e3c949ac1e3330b994641caed96addeb0fdd21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b77d6e39cdb2e4d34ea44d579e3c949ac1e3330b994641caed96addeb0fdd21"
    sha256 cellar: :any_skip_relocation, monterey:       "693554af3ee6cec40d8e4a831f1027d92d50021851e4482c955ada654f7ac6f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "693554af3ee6cec40d8e4a831f1027d92d50021851e4482c955ada654f7ac6f2"
    sha256 cellar: :any_skip_relocation, catalina:       "693554af3ee6cec40d8e4a831f1027d92d50021851e4482c955ada654f7ac6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bba22e595648b03fbd54e4357738b14c52d597b61a5a775a2e250776e48d8733"
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
