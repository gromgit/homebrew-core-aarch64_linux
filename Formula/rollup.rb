require "language/node"

class Rollup < Formula
  desc "Next-generation ES module bundler"
  homepage "https://rollupjs.org/"
  url "https://registry.npmjs.org/rollup/-/rollup-2.73.0.tgz"
  sha256 "00b4a46559ec952e898c65cb1fda06274acf0747e40b05512aeb733262bf2686"
  license all_of: ["ISC", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33eac37f5776937c0eaca84219fa8710f4b01be2e42ddce898e37fc15f56cc6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33eac37f5776937c0eaca84219fa8710f4b01be2e42ddce898e37fc15f56cc6a"
    sha256 cellar: :any_skip_relocation, monterey:       "08a84ec0abe8212dc615fb00169fd8ae78335c05b901cb311e4a1e79ac98e95c"
    sha256 cellar: :any_skip_relocation, big_sur:        "08a84ec0abe8212dc615fb00169fd8ae78335c05b901cb311e4a1e79ac98e95c"
    sha256 cellar: :any_skip_relocation, catalina:       "08a84ec0abe8212dc615fb00169fd8ae78335c05b901cb311e4a1e79ac98e95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7806aa709cb69ed7c4a89cb89a8618ec4c26d76567d9fc44589d460f28891c0f"
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
