require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.5.tgz"
  sha256 "0b4b001d3138375f4e5891fbc2ab24dce55d5d990479cba41132b74ff0b6f4a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5c2066b01a5ae215c76ee10f3002189c730d25968add2a955f7dc35bf8f42b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5c2066b01a5ae215c76ee10f3002189c730d25968add2a955f7dc35bf8f42b8"
    sha256 cellar: :any_skip_relocation, monterey:       "6bdf321485dce745223e1e8e7bcb5b74abfceaa4db6313cbb2fe5ef299acc344"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bdf321485dce745223e1e8e7bcb5b74abfceaa4db6313cbb2fe5ef299acc344"
    sha256 cellar: :any_skip_relocation, catalina:       "6bdf321485dce745223e1e8e7bcb5b74abfceaa4db6313cbb2fe5ef299acc344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a2e1db628e327f5df613c8032f7d896b2c2e1bdf28ea11a7aa2b40473fc528"
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
