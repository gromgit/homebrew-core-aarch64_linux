require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-19.1.1.tgz"
  sha256 "759fdc112d130750fc47ce7ba0fc39fa631349dfcbdb6b97a10c0bd355f82d69"

  bottle do
    cellar :any_skip_relocation
    sha256 "db56419b05b4a2984a8fc4e9c82748ff8136ae7539d95750bef0be691b26a725" => :catalina
    sha256 "e6c305750e8fb94e54425984f5c60bc33fc512e6e04cb8218aaf7612b22c0b92" => :mojave
    sha256 "ac1ecc0139340ef1ee4a829bbf8ca924f4d449b70cf331e62e0e5afcc36ca446" => :high_sierra
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "t.default=getUpdateCommand",
                               "t.default=async()=>'brew upgrade now-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
