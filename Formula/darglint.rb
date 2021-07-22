class Darglint < Formula
  include Language::Python::Virtualenv

  desc "Python docstring argument linter"
  homepage "https://github.com/terrencepreilly/darglint"
  url "https://files.pythonhosted.org/packages/8d/1a/86f981066bc6f9d90d73da0ce09d2084abf1a0fafa9f28fb5130b7186da2/darglint-1.8.0.tar.gz"
  sha256 "aa605ef47817a6d14797d32b390466edab621768ea4ca5cc0f3c54f6d8dcaec8"
  license "MIT"
  head "https://github.com/terrencepreilly/darglint.git"

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring(x):
        """nothing about x"""
        pass
    EOS
    output = pipe_output("#{bin}/darglint -v 2 broken.py 2>&1")
    assert_match "DAR101: Missing parameter(s) in Docstring: - x", output
  end
end
