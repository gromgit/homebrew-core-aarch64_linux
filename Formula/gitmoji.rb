require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.11.tgz"
  sha256 "f34ce2092132696c5ae7057344aa451211cc1de1e4a04e47f5f118c521a1da2b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "33f37f512fe9a01d32677fa44b1c4ca70893326e9d31dbcf3b59d9b4c9e5baf9" => :catalina
    sha256 "5097273ca6a8dcecec45ee77b66c8c7c7c857b6bcb8bf45c250617ffe9ddcd5e" => :mojave
    sha256 "eae6b6d1f181892a6c0401fa6c5f94d533739c92080d3301140a94188819ad8c" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
