class HaruhiDl < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl, focused on bringing a fast, steady stream of updates"
  homepage "https://haruhi.download"
  url "https://files.pythonhosted.org/packages/a9/1d/0d66e53bd2159b38c0d3ed847eb3bfcfa2815ccb78592be12229c9658d24/haruhi_dl-2021.6.24.1.tar.gz"
  sha256 "2ccb9483d6459e83cc8648b4ceb6348665e75aa357680aec90877307375bb6c9"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "51b79aade5e18603ee17b5751dbba9ec7e4b791b907d37eb0a18411a03f80055"
    sha256 cellar: :any_skip_relocation, big_sur:       "edc16bcff5ada20ef26101fa7fc093ef62db483cc878a81309b5a7da35649eb5"
    sha256 cellar: :any_skip_relocation, catalina:      "edc16bcff5ada20ef26101fa7fc093ef62db483cc878a81309b5a7da35649eb5"
    sha256 cellar: :any_skip_relocation, mojave:        "edc16bcff5ada20ef26101fa7fc093ef62db483cc878a81309b5a7da35649eb5"
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
