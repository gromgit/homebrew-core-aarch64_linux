require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.64.0.tgz"
  sha256 "81096681056cb3d2c3760cf3abba6cc3a70be3112303eb38215e39588b91ffec"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1a87475fa07e502053b72db1fb7d5327781fe8f31b9c3853f3f0c04b4c310f47" => :catalina
    sha256 "b81812356eb29fea6cb7822bd5e4603dda37af4cf3e71dc56c79b643d62a8444" => :mojave
    sha256 "18eb195982006e5baf4ee46546ad5df2a968047106e0aeffe23922392b871e92" => :high_sierra
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
