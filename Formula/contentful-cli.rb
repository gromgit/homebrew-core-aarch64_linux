require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.47.tgz"
  sha256 "18eab40913c6391045234bc65b279da14db4f41e80c6783f7d23ea2e0099c58f"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aebfab7ad4c554eb889ec0ed5136db8e67e3bc2c5592eeb572ef2cd0b9834231" => :catalina
    sha256 "9e9d121459d178fec87e7eb735b7967b1bdd9166d5ffb8a9078243dec44807b5" => :mojave
    sha256 "37c22ebddcd6d98b18cd886c5d859297ff52401aee6b0b451c308c0ccd7178f4" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
