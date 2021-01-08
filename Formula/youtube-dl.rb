class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/0c/d7/dab57dd6384db36a9a2752307b321c0719297ea1ee21b17b55cd6a714dd9/youtube_dl-2021.1.8.tar.gz"
  sha256 "1a216c0172b145e7231e8f87f66dc914dce996f993920857b77996fa04e6290c"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "db08076b27062358e75f8418d562801f1d08a3f6bc33a409c87b411934d45726" => :big_sur
    sha256 "ad145152ed367472b3c2584dbe5cff55f6846906f3db386c11ba3f6cd4f4b6b6" => :arm64_big_sur
    sha256 "879c310220247c6dda1c363f64b344696dec79ad10cb46ed098a5c80a58b150b" => :catalina
    sha256 "4dfbc59a3d6ca19bc54075c06321d5f1a97775a0c060ce9e69a6c8dada2fc24d" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
    bash_completion.install libexec/"etc/bash_completion.d/youtube-dl.bash-completion"
    fish_completion.install libexec/"etc/fish/completions/youtube-dl.fish"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
