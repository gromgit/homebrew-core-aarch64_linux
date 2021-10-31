require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.13.12.tgz"
  sha256 "5f131af1aad00544fc1b2daec87fd2cad6752ef2d5d32d8079f573a68abccdb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "526cdf12f8622ca6798fa64f1a1e7f47afd2826debff33bb515e784b49be49e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9137b4121619684da117b0f0ac9664494d9531ea52621465b80378a1c9893bf"
    sha256 cellar: :any_skip_relocation, catalina:      "a9137b4121619684da117b0f0ac9664494d9531ea52621465b80378a1c9893bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "165394a8f78fda0df2e0943b157a4f4afdcc16cbfb2e0a64dda0b1e2228804e7"
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
