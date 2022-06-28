require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-47.2.1.tgz"
  sha256 "ab0bca255977f7f9acdce0e53222f0dc1b18eeb4942aaf3e5928e9a610de568c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05a92ffa27132944a0e5fdb492302453c9c60fd37cd12b119d218ee7920be16b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05a92ffa27132944a0e5fdb492302453c9c60fd37cd12b119d218ee7920be16b"
    sha256 cellar: :any_skip_relocation, monterey:       "ab759dae292c38ff4807460017b66a758300515aeb0781df9cc7653065ed50a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab759dae292c38ff4807460017b66a758300515aeb0781df9cc7653065ed50a6"
    sha256 cellar: :any_skip_relocation, catalina:       "ab759dae292c38ff4807460017b66a758300515aeb0781df9cc7653065ed50a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a92ffa27132944a0e5fdb492302453c9c60fd37cd12b119d218ee7920be16b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
