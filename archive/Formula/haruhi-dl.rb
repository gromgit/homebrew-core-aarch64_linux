class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://git.sakamoto.pl/laudom/haruhi-dl"
  url "https://files.pythonhosted.org/packages/24/f2/a2d22274cfa8f09c849495e8a5106cf72365091b58d55a45c2c91d9f79b9/haruhi_dl-2021.8.1.tar.gz"
  sha256 "069dc4a5f82f98861a291c7edd8bb1ca01eb74602dd36220343a75cb7bb617a8"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/haruhi-dl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "034fd249200cc3a624226be96f3f66c4a934d3676e97552a161e0b67b8f249a7"
  end

  deprecate! date: "2022-01-15", because: :deprecated_upstream

  depends_on "python@3.10"

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
