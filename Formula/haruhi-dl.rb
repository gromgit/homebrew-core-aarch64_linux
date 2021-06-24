class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://haruhi.download"
  url "https://files.pythonhosted.org/packages/e8/67/09bb10e1892c5d8183107981711e9f2db87db33e376e253f3a7340ea3246/haruhi_dl-2021.6.24.tar.gz"
  sha256 "906ec9b8046183cfe097c086c91c91969fd883dbc482ccd5ed8ab67118bede00"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efefacfc9907d9c9121b4fbc436eacadc61a502bf81c1951195754d420528789"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb6c83d8f6a03898850579f0abc08a1cf5e35b4772a00c65acf097cce7b31fb5"
    sha256 cellar: :any_skip_relocation, catalina:      "cb6c83d8f6a03898850579f0abc08a1cf5e35b4772a00c65acf097cce7b31fb5"
    sha256 cellar: :any_skip_relocation, mojave:        "cb6c83d8f6a03898850579f0abc08a1cf5e35b4772a00c65acf097cce7b31fb5"
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
