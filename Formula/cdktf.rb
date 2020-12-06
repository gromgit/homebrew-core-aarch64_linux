require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.0.19.tgz"
  sha256 "6464123578fc9bad863eca6152cac4442711d195482907ddfd4f4220d133f94c"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f480fe5702538db3e3e4e1c55e2c6b2122ba48cac721c84798da3f86c6dc2ad0" => :big_sur
    sha256 "564574ee0ba53d103d0df3d231f40ec4c5aa33a17d463678f03fd5fbe08db80a" => :catalina
    sha256 "d7611317b3f80f5ab7bcc8637ddee610378e017cfbec7c93eed1228a5cefc1b0" => :mojave
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
