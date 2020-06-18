require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.73.1.tar.gz"
  sha256 "c659421b197177ba6c250b50038b4c9eb0c26dcb4216442fb6824245547c51b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e387d83787603d2431eadb5ec9677735675fbdefa1ee7e614dbdb5a844151cc" => :catalina
    sha256 "187756ea8fc97ef0c2c98c0ad63c8e285ac3afd3407e71f3a98db841937de56a" => :mojave
    sha256 "d3c55a19a3591c355a5c20ef3a247f79aa8ef89baf9af66902704cfd37d144c1" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
