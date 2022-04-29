require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.1.0.tgz"
  sha256 "11295ee815d6318e5cfb47e885e37733e1529346ecd272d03fd05a51cc5e5086"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fcf62795dafb916bac51286e8b733d9e7fc83b9a5bcf15c7493b74e01a795c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fcf62795dafb916bac51286e8b733d9e7fc83b9a5bcf15c7493b74e01a795c1"
    sha256 cellar: :any_skip_relocation, monterey:       "937fc10f943b7bd99ea5215c454e30dc9c7ef6677f543abe235e42923912eaff"
    sha256 cellar: :any_skip_relocation, big_sur:        "937fc10f943b7bd99ea5215c454e30dc9c7ef6677f543abe235e42923912eaff"
    sha256 cellar: :any_skip_relocation, catalina:       "937fc10f943b7bd99ea5215c454e30dc9c7ef6677f543abe235e42923912eaff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8361dd797bcd359704de162f9f9c6d6f3a5b041ee208ea11e781add81301f870"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
