require "language/node"

class Terrahub < Formula
  desc "Terraform automation and orchestration tool"
  homepage "https://docs.terrahub.io"
  url "https://registry.npmjs.org/terrahub/-/terrahub-0.4.40.tgz"
  sha256 "ce39d407cf207cdcc0c466141ccfa6c7cd9d0ccb4371f5eb40514baa86636343"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bda38c42bf310ba81b79fe2500098b6619fff880e1cbde80610058dfb94b7f6e" => :big_sur
    sha256 "1eac10b58b87e07c6a7fa6eb7f4dbfcf1ab69b844c88282a6eeee2584056199a" => :catalina
    sha256 "8b31e7961c3ee86fc4f91a30eb6209e79ea465c864859bdef5567de9649f42a2" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".terrahub.yml").write <<~EOF
      project:
        name: terrahub-demo
        code: abcd1234
      vpc_component:
        name: vpc
        root: ./vpc
      subnet_component:
        name: subnet
        root: ./subnet
    EOF
    output = shell_output("#{bin}/terrahub graph")
    assert_match "Project: terrahub-demo", output
  end
end
