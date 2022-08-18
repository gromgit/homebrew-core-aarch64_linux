class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/99/35/e72267645af09ba81fda94b7bef038b661049f48eab14e850e668db7f244/jsonschema-4.10.2.tar.gz"
  sha256 "1a500bb42bd96f54a00aa61213d8595ee9d07c06150c5cd74cb9d307a4a8e40a"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1f3f417977d3f27b5c3d007951ea2815f8286b88ddb4f3909e8296faa9c40b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c22d3fd011fdb44dc5aa9167029ba63a52f14546f461eac2d41e2986393d1eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa2987d6c4d1163581871afbbed403cd2ee2c802934245ad029a876c7c6a5b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ae6bd2892e40270982576162fbba7f0cabef8d732ec0d10060537a53a9f0700"
    sha256 cellar: :any_skip_relocation, catalina:       "36e9193e3d595c7d3173e114e5aebd43878a9e398ac4065c8fc23da741de10c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c70a0ad96b5f315b7015d49f1fb727ac546554899552cd09564ea92bebce5fc"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/42/ac/455fdc7294acc4d4154b904e80d964cc9aae75b087bbf486be04df9f2abd/pyrsistent-0.18.1.tar.gz"
    sha256 "d4d61f8b993a7255ba714df3aca52700f8125289f84f704cf80916517c46eb96"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    EOS

    (testpath/"test.schema").write <<~EOS
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    EOS

    out = shell_output("#{bin}/jsonschema --output pretty --instance #{testpath}/test.json #{testpath}/test.schema")
    assert_match "SUCCESS", out
  end
end
