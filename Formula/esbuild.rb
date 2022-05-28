require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.41.tgz"
  sha256 "f7d65ab366b54916b5c678264d2ee04bcfb5592967f7a4b51304bafe2292fb52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9651eeb48a9f80142d2ae7711f3dc1827071c4feb4da54df16998a4bf605b35d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9651eeb48a9f80142d2ae7711f3dc1827071c4feb4da54df16998a4bf605b35d"
    sha256 cellar: :any_skip_relocation, monterey:       "55689d67800bd3c82319fba2afad845c682c3d67cfcafadc7865587321bc2da4"
    sha256 cellar: :any_skip_relocation, big_sur:        "55689d67800bd3c82319fba2afad845c682c3d67cfcafadc7865587321bc2da4"
    sha256 cellar: :any_skip_relocation, catalina:       "55689d67800bd3c82319fba2afad845c682c3d67cfcafadc7865587321bc2da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc11bdeb63a47ab51c24949e94facad350267882ffbd2b68a83e424d72373b2c"
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
