class Jsonschema < Formula
  include Language::Python::Virtualenv

  desc "Implementation of JSON Schema for Python"
  homepage "https://github.com/Julian/jsonschema"
  url "https://files.pythonhosted.org/packages/6b/a3/06e04a9f2a5de37b75c7b500ab3d6a6dbf565ac83b142054f75dee9f527a/jsonschema-4.3.2.tar.gz"
  sha256 "cca171fb7544de15ccda236bf78d58434d769c9a2ce21d44e0d209e39eeb8876"
  license "MIT"
  head "https://github.com/Julian/jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083afbdda72e6350deb0014b3d703e17e577d90899ef5f2a77b777203167990c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e15dd5ff66105d6cb993a02520ee38bc613ea86b5f7b99aab962d945a996c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4adb19281eb9a22e6e86168d9dd7cff6b618346fa16ca625823996e0c9b950"
    sha256 cellar: :any_skip_relocation, big_sur:        "37efdefdfe096f44c4bd59077c187beb063cae18f74373c3bd6abeddc70debc4"
    sha256 cellar: :any_skip_relocation, catalina:       "811fbca8e0de511e59cbf6e49dc8d4155e040928c47a19bd2aae2db6dfd8b0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa7a3ab6ea6898e2dd73a19aaaa81aa9b3adfb77fa52c529637415454582d4bf"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
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
