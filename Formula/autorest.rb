require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.1.1.tgz"
  sha256 "89f67cbff6e0aee3425da264efb6c1f7dd5b6a12f8e4f3ec43fd0021b962f87b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "9ae3f8b9d2a792ccd96a7ffe4832c1caba05447cb3115d1683ad178fd3151838"
    sha256 cellar: :any_skip_relocation, catalina: "f881d9f1c8868fc18c2f333963ea09efaced0d6e0a8310225bfdad416ad649e6"
    sha256 cellar: :any_skip_relocation, mojave:   "15afe9516721857c75632af739e3ab8efabb873b3ce60cf21e828033c06062d3"
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
