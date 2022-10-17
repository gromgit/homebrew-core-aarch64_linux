require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-3.2.2.tgz"
  sha256 "8b973328c69ff25181a815f885c5294fd1417fb230f577debea0571bcdf5d9dd"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebc8d40acc4f62fc4b3c086993f91d6877089efdd4c7f1160f820eb4437ac92e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebc8d40acc4f62fc4b3c086993f91d6877089efdd4c7f1160f820eb4437ac92e"
    sha256 cellar: :any_skip_relocation, monterey:       "17c8c54800f69222e096a98636c0aee954ea1f539fa8d9387bd2a75d2b514338"
    sha256 cellar: :any_skip_relocation, big_sur:        "17c8c54800f69222e096a98636c0aee954ea1f539fa8d9387bd2a75d2b514338"
    sha256 cellar: :any_skip_relocation, catalina:       "17c8c54800f69222e096a98636c0aee954ea1f539fa8d9387bd2a75d2b514338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10abba546c844ede28f912a17911bd1e13f2d140cc1b34a004605628e05e4738"
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
