class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://files.pythonhosted.org/packages/1f/29/17124ebfdea8d810774977474a8652018c04c4a6db1ca413189f7e5b9d52/ydcv-0.7.tar.gz"
  sha256 "53cd59501557496512470e7db5fb14e42ddcb411fe4fa45c00864d919393c1da"
  license "GPL-3.0"
  revision 3
  head "https://github.com/felixonmars/ydcv.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "549b7b6c442bc91d63c09c5ea887272e47dfefe27ed2879dd5e137af23da7bab" => :big_sur
    sha256 "ce4085dd22c1434dbb030889d1967ba955eb369b89c268660bb2656f21a9e64a" => :arm64_big_sur
    sha256 "0ec0bead521d8569e9b398e08c9baa0ee28d8abee94e0adf478e7a30f7484f91" => :catalina
    sha256 "2e2bacf0d62c5a1496e3ab383e05334c3d36e65312eed0663bdfb2f0e05375e3" => :mojave
  end

  depends_on "python@3.9"

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version

    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      You need to add a config for API Key, read more at https://github.com/felixonmars/ydcv
    EOS
  end

  test do
    system "#{bin}/ydcv", "--help"
  end
end
