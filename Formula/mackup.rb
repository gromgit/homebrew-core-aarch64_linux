class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/cd/28/f3479110f5d628c3df724091300ccffa792e79340513026ea3c5b6d4b7c1/mackup-0.8.30.tar.gz"
  sha256 "c4288e5e5082e3e1d0f2f1654f1c459256413606a9f0a771271ed27882cf6451"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "31dab6ba46535b6e41625b2619c14c978ae8d0b8775ceba32bfa3ce049219e4f" => :big_sur
    sha256 "a60aded418d20f329eb5e0c9327fd4f9f1f00dfb262d940dd2fdf931e7e1f1dd" => :arm64_big_sur
    sha256 "3b85ffa564b7946a9b87d329bc496858ab5217082791fcba0dc402958f23de71" => :catalina
    sha256 "0584365131b6453ea537496a14d103c452528b3ab8f967156c74c8f6f0a1fc11" => :mojave
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
