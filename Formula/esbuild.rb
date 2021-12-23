require "language/node"

class Esbuild < Formula
  desc "Extremely fast JavaScript bundler and minifier"
  homepage "https://esbuild.github.io/"
  url "https://registry.npmjs.org/esbuild/-/esbuild-0.14.8.tgz"
  sha256 "82491d9709a10b887b14e9da61e7090eb007bc1781e5806a9eed6eea990e2b4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fadb403aaa50a34af4f6aebdfc65a9522bd908e0e2b0028af77ddd0dbfe70b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fadb403aaa50a34af4f6aebdfc65a9522bd908e0e2b0028af77ddd0dbfe70b8d"
    sha256 cellar: :any_skip_relocation, monterey:       "62fa10784985e88158a698eb11563cc10b13510e950574745ec3c11f4d23e761"
    sha256 cellar: :any_skip_relocation, big_sur:        "62fa10784985e88158a698eb11563cc10b13510e950574745ec3c11f4d23e761"
    sha256 cellar: :any_skip_relocation, catalina:       "62fa10784985e88158a698eb11563cc10b13510e950574745ec3c11f4d23e761"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c02e4c2815a1a3085a9bca0538cf93cae58b93cb3e814fd7249a14c876998769"
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
