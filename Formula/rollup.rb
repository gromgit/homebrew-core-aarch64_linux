require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.77.2.tgz"
  sha256 "30ac505e8e4f749c78f93c460624a1095b4a9d89101ffa6fcfb3559098e72ac3"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e60dfc9978b569e7dc71a45e3e246ba86ba88693b54198f3f28795c3323e094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e60dfc9978b569e7dc71a45e3e246ba86ba88693b54198f3f28795c3323e094"
    sha256 cellar: :any_skip_relocation, monterey:       "f781764c64a99847db2fbc57975b3c94d3181e7d57650afe455eee2a72a7bc5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f781764c64a99847db2fbc57975b3c94d3181e7d57650afe455eee2a72a7bc5a"
    sha256 cellar: :any_skip_relocation, catalina:       "f781764c64a99847db2fbc57975b3c94d3181e7d57650afe455eee2a72a7bc5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fce5b76016bceac3b177e1547a262d8084c35f043f4b0f76501ce548a88ed4d4"
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
