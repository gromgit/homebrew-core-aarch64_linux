class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/ee/8c/559a72b790e20660dd71bf8d7e638cb811d7df41c11f335b17d358546126/yt-dlp-2021.10.9.tar.gz"
  sha256 "dc6c290ac208b2feda5c6760c20883d9c8128da37630a72894a63b08cf411f29"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d43ae674524f8df7b934efe41ba641ad824089a7aaa123cb5e02a0cea4dd5ce5"
    sha256 cellar: :any_skip_relocation, big_sur:       "4762e8c6d3b38d8d0319a4de0aa38c95ae333ed15b17ecb104b38922e7e369a8"
    sha256 cellar: :any_skip_relocation, catalina:      "e30edb4852c5e0b15819225f3897f65be0e26c8f84a8087c244acc023e8bf60b"
    sha256 cellar: :any_skip_relocation, mojave:        "23a5b14765758aa3d01fcd52e36af633862bccfe7e898dda7e8c2bc9e2d14cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "180f570da0ab7fd1330e4e64c9a0f8c302ebf0f32a344bd4148a6be22ed40267"
  end

  depends_on "python@3.10"

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/f3/d9/2232a4cb9a98e2d2501f7e58d193bc49c956ef23756d7423ba1bd87e386d/mutagen-1.45.1.tar.gz"
    sha256 "6397602efb3c2d7baebd2166ed85731ae1c1d475abca22090b7141ff5034b3e1"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/47/14/dd9ad29cd29ea4cc521286f2cb401ca7ac6fd5db0791c5e9bacaf2c9ac78/pycryptodomex-3.11.0.tar.gz"
    sha256 "0398366656bb55ebdb1d1d493a7175fc48ade449283086db254ac44c7d318d6d"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/1c/f4/61aee1eb4baadf8477fb7f3bc6b04a50fe683ef8ad2f60282806821e4b3b/websockets-10.0.tar.gz"
    sha256 "c4fc9a1d242317892590abe5b61a9127f1a61740477bfb121743f290b8054002"
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
