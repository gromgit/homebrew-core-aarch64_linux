require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.68.5.tgz"
  sha256 "3f75954293d4a79eb8d8ca90a30a79d2abc9f57cfe3101dc19bc8b97e60440cc"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d74db39dc2bc5c5d64c4522f796640d0fba40c90c64427bf5ec24c3694e5f0f1" => :catalina
    sha256 "f5cff0aca14730c9e3f1798e3837b1ac1fb4096d811c906fc230ed2b53a7f7b5" => :mojave
    sha256 "3b1de7bf893810eb64d02f8f89f235806a2dfc3c7c10c3dbc045f41407116acd" => :high_sierra
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
