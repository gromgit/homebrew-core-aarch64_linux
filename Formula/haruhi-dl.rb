class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://haruhi.download"
  url "https://files.pythonhosted.org/packages/a9/1d/0d66e53bd2159b38c0d3ed847eb3bfcfa2815ccb78592be12229c9658d24/haruhi_dl-2021.6.24.1.tar.gz"
  sha256 "2ccb9483d6459e83cc8648b4ceb6348665e75aa357680aec90877307375bb6c9"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ade1ccfd21d9177acb8e31fdb68b03f07b3b184fa90c97362574034776e54e1d"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb23dd6c8909a55b27c200bac5d08d2eee65a14bb378d6ee3e15565c3f287cfb"
    sha256 cellar: :any_skip_relocation, catalina:      "bb23dd6c8909a55b27c200bac5d08d2eee65a14bb378d6ee3e15565c3f287cfb"
    sha256 cellar: :any_skip_relocation, mojave:        "bb23dd6c8909a55b27c200bac5d08d2eee65a14bb378d6ee3e15565c3f287cfb"
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
