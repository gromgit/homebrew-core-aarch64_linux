class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/9d/c7/213df24d4dcf2eb115e2843205c6073c192976684388d6912cf674db2b8a/jsonschema-4.8.0.tar.gz"
  sha256 "c1d410e379b210ba903bee6adf3fce6d5204cea4c2b622d63f914d2dbfef0993"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919821642f71eb9610ce4f4a49b750b5da8d1206acdcd075c2d7e674d45c61d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13275166643e3ef764956888f4c09081d59dec1f7badea1a80634e921863b1cd"
    sha256 cellar: :any_skip_relocation, monterey:       "eabad8fef51ad6e9a3b840d9db028c5c3c552be150a978f3b3d5d839ab4d9246"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a2d7ce97325804b48dbb876e12c2c281c323f66d2b81fafe512746ac8dacfff"
    sha256 cellar: :any_skip_relocation, catalina:       "a7942a8977cd2b75b0283841d30e2a19b34c978ab9c7d12989e3f7bbbc1147d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d74805ad3a1f9707e34c46a00235b81c3d8597aa82b68ccccb47e5331e80c0a9"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
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
