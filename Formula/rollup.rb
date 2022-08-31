require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.79.0.tgz"
  sha256 "79a1776877676c87bddd7b8fe1f35214707164974f013889719bbe7f7f613740"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "081ecbdbe083cd7b2501f0089db83ad7c80502c4542a025b949d17da1f3860cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "081ecbdbe083cd7b2501f0089db83ad7c80502c4542a025b949d17da1f3860cb"
    sha256 cellar: :any_skip_relocation, monterey:       "c5ed3b7c6fec7eb44567dd4dc047fc9e8619796caa0ac7261b4b4482059e9076"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5ed3b7c6fec7eb44567dd4dc047fc9e8619796caa0ac7261b4b4482059e9076"
    sha256 cellar: :any_skip_relocation, catalina:       "c5ed3b7c6fec7eb44567dd4dc047fc9e8619796caa0ac7261b4b4482059e9076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01fc8f6c8b6d038d6ef299c54c4fc3e021cd47e028669eb17f739e126243538f"
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
