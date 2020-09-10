class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.16.tar.gz"
  sha256 "3376c7bcea4b2511e4bcbb4f3b0a04d76a4fdf28f3345755f6d468edaa2fd936"
  license "GPL-3.0-only"
  head "https://github.com/harelba/q.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18c62a2d46208918358284480642afd04422eb1829392bb30ba46aeaed905e28" => :catalina
    sha256 "a009291c7cc9eb49414f85c08786d9e2d069ca00942a713462795b3c7914c0f7" => :mojave
    sha256 "c908b1cdfbbd4c3411f6cf1990abb5d96bccc7e65351a9d921679fe4cedf6fa4" => :high_sierra
  end

  depends_on "python@3.8"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    # broken symlink, fixed in next version
    rm_f "bin/qtextasdata.py"

    virtualenv_install_with_resources
  end

  test do
    seq = (1..100).map(&:to_s).join("\n")
    output = pipe_output("#{bin}/q -c 1 'select sum(c1) from -'", seq)
    assert_equal "5050\n", output
  end
end
