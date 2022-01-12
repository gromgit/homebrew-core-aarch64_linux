class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/Julian/jsonschema"
  url "https://files.pythonhosted.org/packages/26/67/36cfd516f7b3560bbf7183d7a0f82bb9514d2a5f4e1d682a8a1d55d8031d/jsonschema-4.4.0.tar.gz"
  sha256 "636694eb41b3535ed608fe04129f26542b59ed99808b4f688aa32dcf55317a83"
  license "MIT"
  head "https://github.com/Julian/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31cd468959c280602d6f59aa81752af3e53c248dfe3b8970b36e6599606c4253"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24fae0d61406453637e681204f6b56c056d47592346bff7e3cdf566be34a26c0"
    sha256 cellar: :any_skip_relocation, monterey:       "7255282fd57b4b17df42ef2f92a6c2396fb352f673688351c68728504a884657"
    sha256 cellar: :any_skip_relocation, big_sur:        "b74e4f9a7c128946cb64eae604bb785faed85b646626b50f32c8a9350cddb80e"
    sha256 cellar: :any_skip_relocation, catalina:       "8cc2121be2f639cfb82fd59f220127351a32fefe212de2f45213f40d9d05387d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c53ad38d260a7b2591cd992822aa03d2eb9982f1e6bd1d58a52cb6d3ec9ab9fc"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/f4/d7/0fa558c4fb00f15aabc6d42d365fcca7a15fcc1091cd0f5784a14f390b7f/pyrsistent-0.18.0.tar.gz"
    sha256 "773c781216f8c2900b42a7b638d5b517bb134ae1acbebe4d1e8f1f41ea60eb4b"
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
