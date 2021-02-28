class PythonTabulate < Formula
  include Language::Python::Virtualenv

  desc "Pretty-print tabular data in Python"
  homepage "https://pypi.org/project/tabulate/"
  url "https://files.pythonhosted.org/packages/ae/3d/9d7576d94007eaf3bb685acbaaec66ff4cdeb0b18f1bf1f17edbeebffb0a/tabulate-0.8.9.tar.gz"
  sha256 "eb1d13f25760052e8931f2ef80aaf6045a6cceb47514db8beab24cded16f13a7"
  license "MIT"

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-py-tabulate.pth").write pth_contents
  end

  test do
    (testpath/"in.txt").write <<~EOS
      name qty
      eggs 451
      spam 42
    EOS

    (testpath/"out.txt").write <<~EOS
      +------+-----+
      | name | qty |
      +------+-----+
      | eggs | 451 |
      +------+-----+
      | spam | 42  |
      +------+-----+
    EOS

    assert_equal (testpath/"out.txt").read, shell_output("#{bin}/tabulate -f grid #{testpath}/in.txt")
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from tabulate import tabulate"
  end
end
