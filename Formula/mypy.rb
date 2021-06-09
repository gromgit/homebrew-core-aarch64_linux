class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/48/08/9b53a7db56bff609d6cdba02bf8c84069ecc5165540d9a3b73197233d933/mypy-0.901.tar.gz"
  sha256 "18753a8bb9bcf031ff10009852bd48d781798ecbccf45be5449892e6af4e3f9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a72404960416f689a3bfc70537b28deccf6003d937fc0f2ccbf5ef66ccc1f887"
    sha256 cellar: :any_skip_relocation, big_sur:       "f91d5b4cdf147bf3842a8206085890ef07e2bc0e9a4ca9ea7e15e06d29efb823"
    sha256 cellar: :any_skip_relocation, catalina:      "98e78ca77339a90caf679b561547e83c169078c1b5b1e90e024b4b8b1ac26055"
    sha256 cellar: :any_skip_relocation, mojave:        "c03ea7bef371f9a3b5c0afa271126bde84e4713461e20ff179e5dbb654b94740"
  end

  depends_on "python@3.9"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/aa/55/62e2d4934c282a60b4243a950c9dbfa01ae7cac0e8d6c0b5315b87432c81/typing_extensions-3.10.0.0.tar.gz"
    sha256 "50b6f157849174217d0656f99dc82fe932884fb250826c18350e159ec6cdf342"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output
  end
end
