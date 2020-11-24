require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.68.8.tgz"
  sha256 "737c22d37566549e63eec2c23177e910c31b974efb1fafac57ac9befa914c007"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f8a1c369a477bbcadcc4ee261d3ba6c79c9df9fc4369ce66e35fd1af34f79e08" => :big_sur
    sha256 "7fb0af662912dfd5de693e40e4ba0a381f94cf753fa527f67d8ed6da7eaa6584" => :catalina
    sha256 "0d6611268eb590e25d53988dd1db8d2cbb12ae934e9d90350d9c504c3a1e9e2d" => :mojave
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
