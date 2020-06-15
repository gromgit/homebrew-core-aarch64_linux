require "language/node"

class Bcoin < Formula
  desc "Javascript bitcoin library for node.js and browsers"
  homepage "https://bcoin.io"
  url "https://github.com/bcoin-org/bcoin/archive/v2.1.2.tar.gz"
  sha256 "b4c63598ee1efc17e4622ef88c1dff972692da1157e8daf7da5ea8abc3d234df"
  head "https://github.com/bcoin-org/bcoin.git"

  bottle do
    sha256 "9a420ad427d4a90ab88db446476153cfdea523342be2f197fd819a864b96ce32" => :catalina
    sha256 "2b3ca9fccab4a1bbcc965af840d0ed9c66e389fd142074ac8be68ecf187399e2" => :mojave
    sha256 "110585863636021065b56cd48293c73cef80a9fb96d0a8de27a5cc548f429632" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "node"

  def install
    system "#{Formula["node"].libexec}/bin/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"bcoin").write_env_script libexec/"bin/bcoin", :PATH => "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const bcoin = require('#{libexec}/lib/node_modules/bcoin');
      assert(bcoin);

      const node = new bcoin.FullNode({
        prefix: '#{testpath}/.bcoin',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system "#{Formula["node"].bin}/node", testpath/"script.js"
    assert_true File.directory?("#{testpath}/.bcoin")
  end
end
