require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-48.0.0.tgz"
  sha256 "f6de79f949f90185a79754fc68c84bb351f2dbfdf2c746ab9f47b99a9ac2e0aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cc403bcd4677573ba9b5a959c40ad4d0e567e19b0e153c1f3a596efd8de945b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cc403bcd4677573ba9b5a959c40ad4d0e567e19b0e153c1f3a596efd8de945b"
    sha256 cellar: :any_skip_relocation, monterey:       "a20d1f57f17c1ff9cb66afd9bf2448d0ebdc3d9826f91a702e9622042289f592"
    sha256 cellar: :any_skip_relocation, big_sur:        "a20d1f57f17c1ff9cb66afd9bf2448d0ebdc3d9826f91a702e9622042289f592"
    sha256 cellar: :any_skip_relocation, catalina:       "a20d1f57f17c1ff9cb66afd9bf2448d0ebdc3d9826f91a702e9622042289f592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc403bcd4677573ba9b5a959c40ad4d0e567e19b0e153c1f3a596efd8de945b"
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
