require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-44.0.4.tgz"
  sha256 "a81e8ee5ce1bbdb20466ef0d3ea6dae4c08e5b2083b2c8327db887c49671b159"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62f9be5071ffc0156f0b8288e2b2ce5797f4ff78c4e92bfd61d335fb23646561"
    sha256 cellar: :any_skip_relocation, big_sur:       "0af12f31d9a48f72d179770ba019d2fc3798ec198bf16f5f41857c07d9a761ef"
    sha256 cellar: :any_skip_relocation, catalina:      "0af12f31d9a48f72d179770ba019d2fc3798ec198bf16f5f41857c07d9a761ef"
    sha256 cellar: :any_skip_relocation, mojave:        "0af12f31d9a48f72d179770ba019d2fc3798ec198bf16f5f41857c07d9a761ef"
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
