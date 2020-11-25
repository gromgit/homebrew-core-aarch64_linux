class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/79/88/05bc5ff2b03a218650523ee09f00465e95c278fe0105beda24cb756804c7/youtube_dl-2020.11.24.tar.gz"
  sha256 "f701befffe00ae4b0d56f88ed45e1295c151c340d0011efdb1005012abc81996"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "8160bbf37e79e368936244d9629469e4ef2638c51002d2d921fd0f12bc17f85c" => :big_sur
    sha256 "7305c4f4b9b2a1c0c2fe4473f40d26813f0b7ffe4b25c36200f081e09f910deb" => :catalina
    sha256 "cadcbc698b805ad935ebe71f04ee9ef8efa9e06feb94aafa15d92507b5893738" => :mojave
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
