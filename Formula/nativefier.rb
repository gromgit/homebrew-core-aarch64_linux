require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-49.0.1.tgz"
  sha256 "d092716386eb6e05c19694683b4dfecc5d014529d41f86206371ca78fcd100c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbbb57715d0b467de7e82b27ce18f4dcf28fac940bd9eb0dc5881c99cfb11979"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbbb57715d0b467de7e82b27ce18f4dcf28fac940bd9eb0dc5881c99cfb11979"
    sha256 cellar: :any_skip_relocation, monterey:       "fd14c692c55bf2c6b9501b529f1e15a50058f0965a3523fcda33adf46ffa107f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd14c692c55bf2c6b9501b529f1e15a50058f0965a3523fcda33adf46ffa107f"
    sha256 cellar: :any_skip_relocation, catalina:       "fd14c692c55bf2c6b9501b529f1e15a50058f0965a3523fcda33adf46ffa107f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbbb57715d0b467de7e82b27ce18f4dcf28fac940bd9eb0dc5881c99cfb11979"
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
