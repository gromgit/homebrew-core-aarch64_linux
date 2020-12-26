class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/8e/f2/14b34acc03f2185fc24cba33da0d757d6c265149d7b7776c6940008a620e/you-get-0.4.1488.tar.gz"
  sha256 "28aec2f15e86ea1cbf9900827ade41388aa3f1ac43b4ab49999bce48f37cf9c3"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b53a803d844d85abe7f6a14d3ef33fc8867595bc5f58e35f5c4229aaf04f7b8a" => :big_sur
    sha256 "be8623a5faa96a3bb083e03b6340a72e7209b50d35e0fddb9b6f9dc230adc4ad" => :arm64_big_sur
    sha256 "b3c8d2f9616e12c4c97896bdedd334ec69c206bbe521d187c226f4d7a5edcdca" => :catalina
    sha256 "0a8e12599e2eaaf5eceddddb75c04cb3c83a37eb80fbe385023dd05774b11b17" => :mojave
  end

  depends_on "python@3.9"
  depends_on "rtmpdump"

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
