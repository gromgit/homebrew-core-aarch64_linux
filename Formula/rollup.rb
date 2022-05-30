require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.75.3.tgz"
  sha256 "03a7a167ac7a20dfb2154c97a9909b992bd23e07f6f16242229c83b435c008c1"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72fc0c53e8a0bea67dbcc0c0d37363b9027d052c25ae7d6bf6fbd56c7554394c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72fc0c53e8a0bea67dbcc0c0d37363b9027d052c25ae7d6bf6fbd56c7554394c"
    sha256 cellar: :any_skip_relocation, monterey:       "2783572844b132a3ad6e8614265d7b7489d3013c9bba5b71f176bf8b859be8c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2783572844b132a3ad6e8614265d7b7489d3013c9bba5b71f176bf8b859be8c0"
    sha256 cellar: :any_skip_relocation, catalina:       "2783572844b132a3ad6e8614265d7b7489d3013c9bba5b71f176bf8b859be8c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb22d050b0161f3f5bcade472469381c47cfe6b059d993552377d645a63be166"
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
