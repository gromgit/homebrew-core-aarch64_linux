require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.40.tgz"
  sha256 "a20d94c3f20b0c28e07ee8b1b6dc2693ccc40b00383089e83a38683d441cdb1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97a5dfd003d3113040877523977b7112a3edf93b19e46d4631e074a2598a9447"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97a5dfd003d3113040877523977b7112a3edf93b19e46d4631e074a2598a9447"
    sha256 cellar: :any_skip_relocation, monterey:       "395cc12922abd08270196e50b868c8f8ca029dea88ba738de16376a8df907a06"
    sha256 cellar: :any_skip_relocation, big_sur:        "395cc12922abd08270196e50b868c8f8ca029dea88ba738de16376a8df907a06"
    sha256 cellar: :any_skip_relocation, catalina:       "395cc12922abd08270196e50b868c8f8ca029dea88ba738de16376a8df907a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57da66b504681991f8613f7d8f52bfbff611baca2c241075f689b31481227c7b"
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
