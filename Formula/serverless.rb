require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.75.1.tar.gz"
  sha256 "aacb3804e2e20ac6a485b64a85110d05138cd4733c768922cd8aac46c2d0ce5c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "cca254b7bbae4bb513e3fd2aff6991c4310837afbbc764246201159dd10fd53d" => :catalina
    sha256 "b4ce0ce0f8a3a24dce8e085162d9ae5b32f792e2f6ec79152c4ebd65cb98f85b" => :mojave
    sha256 "908e91c6477a3e1e532b125e97ba35f3c17c2314aae1beb9150e32715e6cccff" => :high_sierra
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

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
