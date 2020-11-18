class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/fa/8e/1c5641b98b8a256d0f1bd5f2fc7f80d4823d1c6f0a3b70c18c8ae7ddae41/youtube_dl-2020.11.18.tar.gz"
  sha256 "fd879801004d80d875680041d8dcba25bd36cfdaeb0ca704607f16b3709a4f21"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "0112bf9eb5f3c344d34bb992c81d0480b13289d6081130f325f5944aabba2af2" => :big_sur
    sha256 "352c4170a73c0de9a752b0c59a021c4430b4402173c128b0cc88688149a48fa9" => :catalina
    sha256 "fbe738e4de400a773e4a4a3930b2f863da4b6c6d2cc640f47c48b6257c5ff0d3" => :mojave
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
