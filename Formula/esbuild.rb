require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.44.tgz"
  sha256 "34333f9746c74375d059b0403ae4bc0c458b6854a92a3c679c554f682b3fa834"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de42f7f899b99d1a779fe69ea4b33ffa339876aea66f9390be370f8072a18685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de42f7f899b99d1a779fe69ea4b33ffa339876aea66f9390be370f8072a18685"
    sha256 cellar: :any_skip_relocation, monterey:       "74ae6aad24e74290f77d90274b3133a306bc9cd27b6f62b7ff84a9ad444dc30a"
    sha256 cellar: :any_skip_relocation, big_sur:        "74ae6aad24e74290f77d90274b3133a306bc9cd27b6f62b7ff84a9ad444dc30a"
    sha256 cellar: :any_skip_relocation, catalina:       "74ae6aad24e74290f77d90274b3133a306bc9cd27b6f62b7ff84a9ad444dc30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d367d5fe6a92757ad0775cb2d09b50e416baa7ac64dbfe5b0ed21e0db61237"
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
