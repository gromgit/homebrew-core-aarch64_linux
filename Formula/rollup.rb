require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.1.0.tgz"
  sha256 "4d3bd8a2044f5cc238c18d0b4482fd8b659e4613102fd4861974a1545a2f92fa"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b5baadeeebc371e63ef8cf17ef4202a5dcd576aa0ff35e66bcd32730aeed96f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b5baadeeebc371e63ef8cf17ef4202a5dcd576aa0ff35e66bcd32730aeed96f"
    sha256 cellar: :any_skip_relocation, monterey:       "64f8ed250bfa38e1d8d279d504eb515665f68336bb40ce99d672c4fc4b6f97ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "64f8ed250bfa38e1d8d279d504eb515665f68336bb40ce99d672c4fc4b6f97ca"
    sha256 cellar: :any_skip_relocation, catalina:       "64f8ed250bfa38e1d8d279d504eb515665f68336bb40ce99d672c4fc4b6f97ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e3c4ba8e14967f0eeb2c5bc7d8aa087491023ea46bfcad45d3268ed8191402"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"test/main.js").write <<~EOS
      import foo from './foo.js';
      export default function () {
        console.log(foo);
      }
    EOS

    (testpath/"test/foo.js").write <<~EOS
      export default 'hello world!';
    EOS

    expected = <<~EOS
      'use strict';

      var foo = 'hello world!';

      function main () {
        console.log(foo);
      }

      module.exports = main;
    EOS

    assert_equal expected, shell_output("#{bin}/rollup #{testpath}/test/main.js -f cjs")
  end
end
