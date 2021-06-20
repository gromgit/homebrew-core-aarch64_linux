class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://haruhi.download"
  url "https://files.pythonhosted.org/packages/50/b6/4834af1bac4d81802a8407d918b8d70df41c49f01aa0721104fcf5652c9e/haruhi_dl-2021.6.20.tar.gz"
  sha256 "c35e10f8c1c691520a4df4b74a45c8d5beca3f83c121277bc0eef132475770a6"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fc3aa6938b942b48f5449ee5d1b6ae8cf25912ad4f7647f22e2b61296c339fc5"
    sha256 cellar: :any_skip_relocation, big_sur:       "fe067db3e867b03e593b8fee77276216e0db7ad79f3001115e1d8e1d95d213d0"
    sha256 cellar: :any_skip_relocation, catalina:      "fe067db3e867b03e593b8fee77276216e0db7ad79f3001115e1d8e1d95d213d0"
    sha256 cellar: :any_skip_relocation, mojave:        "fe067db3e867b03e593b8fee77276216e0db7ad79f3001115e1d8e1d95d213d0"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # History of homebrew-core (video)
    haruhi_output = shell_output("#{bin}/haruhi-dl --simulate https://www.youtube.com/watch?v=pOtd1cbOP7k")

    expected_output = <<~EOS
      [youtube] pOtd1cbOP7k: Downloading webpage
      [youtube] pOtd1cbOP7k: Downloading MPD manifest
    EOS

    assert_equal expected_output, haruhi_output
  end
end
