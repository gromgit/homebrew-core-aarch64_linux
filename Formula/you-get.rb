class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1388.tar.gz"
  sha256 "17bbb545efbd0898fe48311df33d6288049dcae5f4a2132da70a1072f019b96b"
  revision 2
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e66ba7133b8196a6d24617a8ae313101ec006864ad27e7073dabcbc37f47512" => :catalina
    sha256 "c3a8453329addc500d0f5d5a82749d8a3a088529f9341b5a126b96abd8c428f9" => :mojave
    sha256 "dd1bc1b83a0abb1da2923da2b1ef5d0c2cbad847f804a245153468c2cafdf74e" => :high_sierra
  end

  depends_on "python@3.8"
  depends_on "rtmpdump"

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
