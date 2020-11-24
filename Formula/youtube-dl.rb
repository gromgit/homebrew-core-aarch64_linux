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
    sha256 "2f8a82a4cec363105b0bd47bbdd8d2b77b2b9f4081f28f2e518bf079570429a7" => :big_sur
    sha256 "6fa05a6ef2b453405a6acf28e30619228a1b670186b4c7b3140f71a74c86543d" => :catalina
    sha256 "895248fdbb967d82bf9c6520f953abe7c272e541a033f71445df9a0cf5e7f4f5" => :mojave
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
