require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.13.4.tgz"
  sha256 "0c4662e067398ef112eb805887dfd4459149831f79d8f1d9ed68b7a2fa262890"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c736d9578d23f1d1d953cf495fb58e25e436d191565766b9eed714d759b9bb5d"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a3d96f32b1b14a10c4804616c68bd2182bc78372955b109525461dd99863a54"
    sha256 cellar: :any_skip_relocation, catalina:      "83e22c61a3006ff5d1e8a43d5126444bc93123baf1fc8573971e34cae76f044b"
    sha256 cellar: :any_skip_relocation, mojave:        "86c05735a94cc762628c9cf1c48c266d84380eec6d369bc57b34668b81c1c017"
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
