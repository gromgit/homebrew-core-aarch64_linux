class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/f3/81/86da9f2bcbea4d7315f05bbf4c12ef74fee5eddd64f9c5255e8f1e410bc2/youtube_dl-2020.11.26.tar.gz"
  sha256 "3d52d2c969ec9521a086c43f809fd7545708b7ba24d7379fb123b5438ba691e1"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fbc1ea5f42cc06e10e50cc3beaa3597c7ab9fa7c49a160d4241ba7fffe0029b" => :big_sur
    sha256 "ebde2db428b244f2caccde9655c658443adc82d2e79f8671dcb51c7dfa673c05" => :catalina
    sha256 "3e28af7663ce5209a258aa63366d4f77da7f79155d1c5eef70329e09b8543e62" => :mojave
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
