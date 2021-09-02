class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/10/4b/7ac9cced452f67f3d75ea460eb07c8dd377b8cc60337b6ae465e38f6b2d7/yt-dlp-2021.9.2.tar.gz"
  sha256 "ca7e77cdb055ba2683df5b0807aab1c1e120cbe02c8f35d9d3293d94dbdaea63"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f503cbee48071e8a68be5b5fce36fa5fc1831f84e66c03947ff7f547a46846ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "82db06f90b071567052a368ec9c79d03d528caf4ec4da0b0b7e2f833f70a43af"
    sha256 cellar: :any_skip_relocation, catalina:      "197772e4298796c6adf4265bd11998dff01e8f284218d1e523a8aa5d86aa9b98"
    sha256 cellar: :any_skip_relocation, mojave:        "153eebc4ad1476cdd9c6d653fdb99e42763f67c1141b6447c5d391bf8783495e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8acf080638031bfb13c1c88181199f2ee79f9c6a282524c9395c652cc2605307"
  end

  depends_on "python@3.9"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/88/7f/740b99ffb8173ba9d20eb890cc05187677df90219649645aca7e44eb8ff4/pycryptodome-3.10.1.tar.gz"
    sha256 "3e2e3a06580c5f190df843cdb90ea28d61099cf4924334d5297a995de68e4673"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/0d/bd/5262054455ab2067e51de331bfbc53a1dfa9071af7c424cf7c0793c4349a/websockets-9.1.tar.gz"
    sha256 "276d2339ebf0df4f45df453923ebd2270b87900eda5dfd4a6b0cfa15f82111c3"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/yt-dlp.1"
    bash_completion.install libexec/"share/bash-completion/completions/yt-dlp"
    zsh_completion.install libexec/"share/zsh/site-functions/_yt-dlp"
    fish_completion.install libexec/"share/fish/vendor_completions.d/yt-dlp.fish"
  end

  test do
    # "History of homebrew-core", uploaded 3 Feb 2020
    system "#{bin}/yt-dlp", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # "homebrew", playlist last updated 3 Mar 2020
    system "#{bin}/yt-dlp", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
