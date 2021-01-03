class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/28/1b/39e12cb3fba1dad657cc8a23c87370eef8e6646868f4ee4c3549dfd77fec/mackup-0.8.31.tar.gz"
  sha256 "a905f8e93c4fda0cdb6e1cc71f866c619d5bb5109d95f5c0ce101dff7efcefd7"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "59cffa819c8619850341ccc11813648c8b421ec3fa73d0d116dbfb23fddae796" => :big_sur
    sha256 "b69073a4a6b88a58eecd4bd274b5bfc50ef649712016aacbef3b0509aece6425" => :arm64_big_sur
    sha256 "177e2e6cefb3cbbb301727dfb30d116b46b9a0a17e67f9601f226902946537f1" => :catalina
    sha256 "9e1913542a61f77ca193300af533ef3d29a26f6862ab8d1d4b2eabfdd4dce47f" => :mojave
  end

  depends_on "python@3.9"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
