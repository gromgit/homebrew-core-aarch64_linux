require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.10.tgz"
  sha256 "5bddabd8ab84e539b608c043f71a709bca821560ea1ee22a779a0f6ce3f18994"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aed39b75845473da8df1693f8ed5aaf3a8bf9be8196eca892a9e6631435b2255"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aed39b75845473da8df1693f8ed5aaf3a8bf9be8196eca892a9e6631435b2255"
    sha256 cellar: :any_skip_relocation, monterey:       "28e20bf64f04590aece296514fd0fe224b67b41703791b344ea3e700b2a57517"
    sha256 cellar: :any_skip_relocation, big_sur:        "28e20bf64f04590aece296514fd0fe224b67b41703791b344ea3e700b2a57517"
    sha256 cellar: :any_skip_relocation, catalina:       "28e20bf64f04590aece296514fd0fe224b67b41703791b344ea3e700b2a57517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1d4331c4545268f36ed4c3c11089a9b9e3ac582a901454c7498940f3cb9e9d6"
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
