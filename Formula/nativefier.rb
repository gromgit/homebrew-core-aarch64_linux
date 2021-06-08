require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-44.0.2.tgz"
  sha256 "c8fc75441411eccdfab1fb0e8eac109ec2e4e9676f7238dc41c29b7f88737afe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6b8e793f269d00adb404212ecf1a9e18df649a8a4dfbec72a731826bdc91c533"
    sha256 cellar: :any_skip_relocation, big_sur:       "351c3f435fe13bbfc232220647869f2ae8647fb4eca45c4442b7567573502893"
    sha256 cellar: :any_skip_relocation, catalina:      "351c3f435fe13bbfc232220647869f2ae8647fb4eca45c4442b7567573502893"
    sha256 cellar: :any_skip_relocation, mojave:        "351c3f435fe13bbfc232220647869f2ae8647fb4eca45c4442b7567573502893"
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
