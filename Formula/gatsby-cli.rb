require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.4.tgz"
  sha256 "c267125d36cd1327e94f12a558379fc80c143e9227e4717894b29e2d969634f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1ff9ef04daf3c1babc110f7be4a2f864708b28ddadb1e44df590c0f11bc78ff" => :catalina
    sha256 "578ea179b85acf4dd2a49667c3c9fd3d53230c83d9c073a1c82969310d62ad6a" => :mojave
    sha256 "005013fd2ee8d9d9265e9d11eea8221f3db7863f4851dc2c43486ee1d18baece" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
