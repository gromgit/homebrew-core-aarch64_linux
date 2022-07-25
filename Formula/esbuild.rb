require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.50.tgz"
  sha256 "af0a48f7521ccde10e2f49db1c4bb9155530921a9a4cfdb9a774bdbabb5b12e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1657401e5bd83991e73cb5329adb7fa92702c231e229a73db6e1262a651c9db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1657401e5bd83991e73cb5329adb7fa92702c231e229a73db6e1262a651c9db"
    sha256 cellar: :any_skip_relocation, monterey:       "1c728b24024c2acfa6ab3c4325845c5f53bcc2c6d8ea7b9cf3b1d8dd5e1eca3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c728b24024c2acfa6ab3c4325845c5f53bcc2c6d8ea7b9cf3b1d8dd5e1eca3e"
    sha256 cellar: :any_skip_relocation, catalina:       "1c728b24024c2acfa6ab3c4325845c5f53bcc2c6d8ea7b9cf3b1d8dd5e1eca3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1528bf7f9250ed56dc02ce4ba33583760dece9f4df6e43aeae98057af6824d5e"
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
