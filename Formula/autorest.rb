require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.0.6338.tgz"
  sha256 "28c1fb3d51629ef2a5a2ac7598a306ca6b398af17853189148feee66baf6b015"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "efc8ea6483ea4be47b68d1fbeda0cb547887df62f904392da4c57426f07962c1"
    sha256 cellar: :any_skip_relocation, catalina: "2beeb573f9de89c189617659aef625da0aa7dbf466a3f1e1d6192712f39e9878"
    sha256 cellar: :any_skip_relocation, mojave:   "6e07e8f9b93b062594dbe37ca1c07abd59fa63efd00d27d7b209992f14a430f3"
  end

  depends_on "node"

  resource "petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--nodejs",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
