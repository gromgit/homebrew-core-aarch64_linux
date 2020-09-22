class Q < Formula
  include Language::Python::Virtualenv

  desc "Run SQL directly on CSV or TSV files"
  homepage "https://harelba.github.io/q/"
  url "https://github.com/harelba/q/archive/2.0.19.tar.gz"
  sha256 "cd4c60923bc40f53d974b54849f76096bf9901407c618cd0a3ccbc322aacc97d"
  license "GPL-3.0-or-later"
  head "https://github.com/harelba/q.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce6de63e5ae0de8e3f892736348d6e749b62b3ba5e6f81fa8735928fe4757a24" => :catalina
    sha256 "fea8bb5f0ed27921dc5a6a8854158c96822ae489492495720e00e2e987b36f72" => :mojave
    sha256 "4c839623778884c788ea838276b1d486d639f683eb00820d5be1b169e17389a3" => :high_sierra
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
