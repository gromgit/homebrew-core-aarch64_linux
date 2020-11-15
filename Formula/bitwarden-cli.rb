require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.13.2.tgz"
  sha256 "0806f897dd66d31d2ee48a15aa43a9c6e796655c64221e81d9e5122c574dde5c"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b11f8cc6aa79e2cac76319be59fe77b09f39c592c9dfac66dc17169683c5a83b" => :catalina
    sha256 "bb8bede4fa99caa9d0d4e5ec93f7c42b42868395da3693c8849119129fd5873e" => :mojave
    sha256 "e714a7f95873ff28f858c727b68846014514c9dea4df4a607dad9e940ff7b7f3" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
