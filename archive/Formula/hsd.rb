require "language/node"

class Hsd < Formula
  desc "Handshake Daemon & Full Node"
  homepage "https://handshake.org"
  url "https://github.com/handshake-org/hsd/archive/v3.0.1.tar.gz"
  sha256 "2952dd9fe5c1d5db448e0881cc1656c5efaa61cb6030c4bc629e04f53feec3b4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256                               arm64_monterey: "fb0a7c2d44075faa68da8389694f08057a0c758d44fcb9dc1280094c9479486f"
    sha256                               arm64_big_sur:  "416657d1f26523569bc1f3dac307482f852ebb6f5080875d7038c13c7283f948"
    sha256                               monterey:       "5f73a93dfaed62d30e3ff916e39c247f4fa7b216c1661d287b9dcfa428d361c4"
    sha256                               big_sur:        "adfb582d7191da242f522df403b180be8900177606be0641aca2a60d071c855d"
    sha256                               catalina:       "5e9761cd4c9d23ef7ca4f13e6647901b0cbe0f3ee357621dcd9da81f956b4651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3ac1555d77c37e1fe74f74eaa033006216c666a606e37f72005a2bde090779"
  end

  depends_on "python@3.10" => :build
  depends_on "node@14"
  depends_on "unbound"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"hsd").write_env_script libexec/"bin/hsd", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
    bin.install_symlink libexec/"bin/hsd-cli"
    bin.install_symlink libexec/"bin/hsw-cli"
  end

  test do
    (testpath/"script.js").write <<~EOS
      const assert = require('assert');
      const hsd = require('#{libexec}/lib/node_modules/hsd');
      assert(hsd);

      const node = new hsd.FullNode({
        prefix: '#{testpath}/.hsd',
        memory: false
      });
      (async () => {
        await node.ensure();
      })();
    EOS
    system "#{Formula["node@14"].opt_bin}/node", testpath/"script.js"
    assert File.directory?("#{testpath}/.hsd")
  end
end
