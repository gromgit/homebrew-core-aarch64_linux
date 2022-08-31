require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.79.0.tgz"
  sha256 "79a1776877676c87bddd7b8fe1f35214707164974f013889719bbe7f7f613740"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edd829a972507e1fd3bf03a5a0af0b279a1dd8c6655ab3a3bdfda46befcdac72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edd829a972507e1fd3bf03a5a0af0b279a1dd8c6655ab3a3bdfda46befcdac72"
    sha256 cellar: :any_skip_relocation, monterey:       "3d0e9d9495d5266fddb5bfd5990e37e6ee0fe9b0640b09187aaba166db26d1ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d0e9d9495d5266fddb5bfd5990e37e6ee0fe9b0640b09187aaba166db26d1ea"
    sha256 cellar: :any_skip_relocation, catalina:       "3d0e9d9495d5266fddb5bfd5990e37e6ee0fe9b0640b09187aaba166db26d1ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037ddf0f12a13507c936478825aee9b47fd20971ebfa6e613a74648fdf0cea33"
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
