require "language/node"

class Zx < Formula
  desc "Tool for writing better scripts"
  homepage "https://github.com/google/zx"
  url "https://registry.npmjs.org/zx/-/zx-7.0.4.tgz"
  sha256 "23050f7c000541792f7ab5dbecce1be5519429a42bb90386860b55258a60a8a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b3cc14426c3c204a242759a5e521553454181471a454a7b038e7954865f9b0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b3cc14426c3c204a242759a5e521553454181471a454a7b038e7954865f9b0a"
    sha256 cellar: :any_skip_relocation, monterey:       "c662d81be27cb945d092d56deb42382d63665e356073394e252d923e95ffdd94"
    sha256 cellar: :any_skip_relocation, big_sur:        "c662d81be27cb945d092d56deb42382d63665e356073394e252d923e95ffdd94"
    sha256 cellar: :any_skip_relocation, catalina:       "c662d81be27cb945d092d56deb42382d63665e356073394e252d923e95ffdd94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3cc14426c3c204a242759a5e521553454181471a454a7b038e7954865f9b0a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.mjs").write <<~EOS
      #!/usr/bin/env zx

      let name = YAML.parse('foo: bar').foo
      console.log(`name is ${name}`)
      await $`touch ${name}`
    EOS

    output = shell_output("#{bin}/zx #{testpath}/test.mjs")
    assert_match "name is bar", output
    assert_predicate testpath/"bar", :exist?

    assert_match version.to_s, shell_output("#{bin}/zx --version")
  end
end
