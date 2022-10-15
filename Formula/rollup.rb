require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.2.0.tgz"
  sha256 "39bacf48d0379987d74ae7c91b908a85aafde93ce38fde2ae9f45f610d728fb6"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21db49215e326aab4701d1f999d3f282880cbbe52819752653929dbb6afb489d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21db49215e326aab4701d1f999d3f282880cbbe52819752653929dbb6afb489d"
    sha256 cellar: :any_skip_relocation, monterey:       "a36b149118d9e9bcfbee210354a5639e7c40bf2b8f0acbff7458cb956676a652"
    sha256 cellar: :any_skip_relocation, big_sur:        "a36b149118d9e9bcfbee210354a5639e7c40bf2b8f0acbff7458cb956676a652"
    sha256 cellar: :any_skip_relocation, catalina:       "a36b149118d9e9bcfbee210354a5639e7c40bf2b8f0acbff7458cb956676a652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ed74960bd067c89852c403b314a21b1f40f4f4eb4c626886f71de9eccb434c"
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
