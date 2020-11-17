class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/a0/71/7120a61017be8237c4584c2ac6776045d553958794c8565ea9c9b842fc88/youtube_dl-2020.11.17.tar.gz"
  sha256 "933519ab7d2fa05bd28f8443a2115d21efd0355c051986548af9f233e300db0b"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "68bea91f5a45510551eab56885138cf9f84a21e4a7ca62119fab5b3923c2baae" => :big_sur
    sha256 "b92dd1921c1b0524621eec246263e45fed6394e4e12d7f36f7b7ce1b97dfd061" => :catalina
    sha256 "6722f9c1a59e8325e3e2b39d08fdf30faeddee7722f5d50705acf2c3576482dc" => :mojave
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
