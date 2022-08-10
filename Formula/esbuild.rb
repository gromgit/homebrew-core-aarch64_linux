require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.0.tgz"
  sha256 "a580f416a4437c3922dcab9c234b36cab1b3d385a53efb4d663972019c38ef60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9670b41c5fad0b80b9ab3a64348188866b0c7203f698b3511c150c45ad5f430e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9670b41c5fad0b80b9ab3a64348188866b0c7203f698b3511c150c45ad5f430e"
    sha256 cellar: :any_skip_relocation, monterey:       "6b8df0b96fca15ddaebe37011d1b8f80d3b6c273add279736fbb8bec0c0f70c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b8df0b96fca15ddaebe37011d1b8f80d3b6c273add279736fbb8bec0c0f70c5"
    sha256 cellar: :any_skip_relocation, catalina:       "6b8df0b96fca15ddaebe37011d1b8f80d3b6c273add279736fbb8bec0c0f70c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04f64550ecf0a4e01f56cf7ca5ecda7f8c2910af3dc8d34fe1409a621cf448b4"
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
