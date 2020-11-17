class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/a0/71/7120a61017be8237c4584c2ac6776045d553958794c8565ea9c9b842fc88/youtube_dl-2020.11.17.tar.gz"
  sha256 "933519ab7d2fa05bd28f8443a2115d21efd0355c051986548af9f233e300db0b"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fc5f54b3319c10a1625d08c580b6faf9445307acf0df642a6fc73ae8a88ee41" => :big_sur
    sha256 "4c71c4df2322e5a31e36123d529031b7af2e6626f94bfa79857835df40c7a589" => :catalina
    sha256 "ede378615a66acc53a13a07b6ee4384ac74decb832179b8893a70ae550c73712" => :mojave
    sha256 "a5bb66156c7c2d8a8beff32358efb1bc342514397e13be4eaf7b05c6cae0b54e" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
