require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.15.6.tgz"
  sha256 "87db715f388891382017815a3a341ef067c4f810efabce53b07bd84e15c251f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46762b5c94a1a0eecdaa6cbc29dd9145529e3843099e5336d45d10d14ccc5834"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46762b5c94a1a0eecdaa6cbc29dd9145529e3843099e5336d45d10d14ccc5834"
    sha256 cellar: :any_skip_relocation, monterey:       "082ecc2559c75fe410a2a1405125d9e1e42fee932f334cecab53663fa89bc871"
    sha256 cellar: :any_skip_relocation, big_sur:        "082ecc2559c75fe410a2a1405125d9e1e42fee932f334cecab53663fa89bc871"
    sha256 cellar: :any_skip_relocation, catalina:       "082ecc2559c75fe410a2a1405125d9e1e42fee932f334cecab53663fa89bc871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e18e85ef422d9695685825b4607f4791fc7f7bd33728d03642399bb79ea6b9f1"
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
