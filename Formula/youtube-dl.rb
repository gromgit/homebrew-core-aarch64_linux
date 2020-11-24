class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/76/03/a5c749ea2ddeac51dcd0376d8519868ca710dd241c871f555765e777c5bf/youtube_dl-2020.11.21.1.tar.gz"
  sha256 "a785c1373a3c2d0b82c54aabc4831e8e6f6ede059ec462e54526d694dd3c29ca"
  license "Unlicense"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "eaccafc614961180a0f8c171b603a6519fe29a18cbc28e81cb874e6e25294be0" => :big_sur
    sha256 "4b778d9b2d312f9e55765bc054b160e60f1c68c9f02ad453620282b2e074c17f" => :catalina
    sha256 "5263bbe0d53d74e372398b9c6ebb7416a8d400b735e1cebd1e75142a3e11c398" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
