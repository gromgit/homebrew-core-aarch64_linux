class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/e7/9e/a03636247367e791cdbde6b655a1cbe78b72c40c43f605bb6096c2f1290f/youtube_dl-2021.4.1.tar.gz"
  sha256 "2715ca9fc4cd3c0eafa56cba9dfacc699fa6176ca083e903becaddd108d8db7b"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1939620cae73729dffa8aa6151803351b72570c82cb5603c73f822f0344d8e22"
    sha256 cellar: :any_skip_relocation, big_sur:       "332a971bcdd3abffcebb9b1ab6ca1b77eb076fbc0ade3bb6610a8487b96c166b"
    sha256 cellar: :any_skip_relocation, catalina:      "305bc5a36933a5916791afaac513c2e4ef103216c927a2f3a09a156a8702bbb8"
    sha256 cellar: :any_skip_relocation, mojave:        "d3d5eba75aa1205fcb7948036b1d56996a1f538a032324a5abce42ad4390d595"
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
