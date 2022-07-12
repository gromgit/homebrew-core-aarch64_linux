class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/python-jsonschema/jsonschema"
  url "https://files.pythonhosted.org/packages/19/0f/89db7764dfb59fc1c2b18c2d63f11375b4827aa3e93ae037166a780d2bed/jsonschema-4.7.2.tar.gz"
  sha256 "73764f461d61eb97a057c929368610a134d1d1fffd858acfe88864ee94f1f1d3"
  license "MIT"
  head "https://github.com/python-jsonschema/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3325ce39cb23e2ed4eaa0fd9a0d74b5f23b8d557cf8decfb6dc7c4d294c8607a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0aebf0a54a01c503a0a0c1a811395e79aa0d80d86d2d201aba6277f872cf4f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "1e7542738632cd06838cd2ff010250f75a235459de880ba89efdcdd35b171704"
    sha256 cellar: :any_skip_relocation, big_sur:        "4642253e6223587e1381670b51633971f72115ca73e6d6990d9db6f3b4709a53"
    sha256 cellar: :any_skip_relocation, catalina:       "c619505107bfcdce6ea3a0d21799433e29eb4b9530409444902209c217a6fbaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fdd5529e56be0710819443109fc6145d34fe74662ebfef70799cc3b1dd36338"
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
