class YtDlp < Formula
  include Language::Python::Virtualenv

  desc "Fork of youtube-dl with additional features and fixes"
  homepage "https://github.com/yt-dlp/yt-dlp"
  url "https://files.pythonhosted.org/packages/d0/7a/40aa2c5e8b25e4c0ee8e00963507acc104f68d03b540e6a3686f331b3bec/yt-dlp-2021.9.1.tar.gz"
  sha256 "efefbec227a014aaecb7b3c5d4e1649de474802058598a9c0281ee020e0d1cb6"
  license "Unlicense"
  head "https://github.com/yt-dlp/yt-dlp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff359d4172f8908f5c280d62b99b82d14b2f8f4e948fb816ce38101d6bd34dd5"
    sha256 cellar: :any_skip_relocation, big_sur:       "26b0faf7ffd57565adc26830b51226f1ac56c8a15264a01fad1a9b7b2b91042b"
    sha256 cellar: :any_skip_relocation, catalina:      "26b0faf7ffd57565adc26830b51226f1ac56c8a15264a01fad1a9b7b2b91042b"
    sha256 cellar: :any_skip_relocation, mojave:        "26b0faf7ffd57565adc26830b51226f1ac56c8a15264a01fad1a9b7b2b91042b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b1572be11deeda225cf2db27164a96aed5e5b5fdb8dde7da7ba4383f3a9566f"
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
