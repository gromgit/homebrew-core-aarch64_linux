require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.2.tgz"
  sha256 "a79b5c6522b5316205ea76b344e2a7b7682f0d73621aa20ac8dc981c5cf3a6d5"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d84fbcecde29f2e722d6d90e0a4bc2ddd2546171320cb942a0b927d77c721cbc" => :big_sur
    sha256 "b50692c58db901ef4167ef96e8c74b3380a75bc86f812a482d94065185ac7594" => :catalina
    sha256 "8ee7df5a9845ee24c6565b5d70b2eaa402b1483d06d85a44985ee7209ad7ec94" => :mojave
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
