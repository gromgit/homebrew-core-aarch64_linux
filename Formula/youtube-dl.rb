class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/21/b4/b910f76850b9e5d9022ff80e55e1fee793b20c3cbbbe0310c9ea67ac059b/youtube_dl-2021.3.25.tar.gz"
  sha256 "375c19339fd6b64cb09f174c4681159a88352c5559c3453dc082020adea2980e"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3cbeeba083449acf0dc719a60a4b267c952d1977aa6372abee378a9d39108a71"
    sha256 cellar: :any_skip_relocation, big_sur:       "1fc1cc1befa83f86f4062564275929dc0469992905a00cc373f5b11a63c9fab2"
    sha256 cellar: :any_skip_relocation, catalina:      "7d1f46c841d9e0c25ca7f0f756adea1138e11a09776ebe9a0986a62e8d4368bf"
    sha256 cellar: :any_skip_relocation, mojave:        "c023a2e01b617d5d0a86ca0efee08e8cda395de424ee8b61fbd5c99f4985f549"
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
