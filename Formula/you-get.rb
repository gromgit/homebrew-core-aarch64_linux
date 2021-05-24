class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/ce/48/ac9a960df2af7ab1c6afe80853320d4d76b219727ff2a2e513cd006d2bdb/you-get-0.4.1525.tar.gz"
  sha256 "905eae25a7d2aef2262cb6a2cabd036381a6c6c6cc8746e13c4a8fde4602911c"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61ae27ceb46e418b8be3d42fd09a09aee0a392f1a569d821be945555ddcc990e"
    sha256 cellar: :any_skip_relocation, big_sur:       "88e9697583588134f388bc1055980f957e2686438f7167fa2994e712eb3f8d1f"
    sha256 cellar: :any_skip_relocation, catalina:      "88e9697583588134f388bc1055980f957e2686438f7167fa2994e712eb3f8d1f"
    sha256 cellar: :any_skip_relocation, mojave:        "88e9697583588134f388bc1055980f957e2686438f7167fa2994e712eb3f8d1f"
  end

  depends_on "python@3.9"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
