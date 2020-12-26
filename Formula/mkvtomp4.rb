class Mkvtomp4 < Formula
  include Language::Python::Virtualenv

  desc "Convert mkv files to mp4"
  homepage "https://github.com/gavinbeatty/mkvtomp4/"
  url "https://files.pythonhosted.org/packages/89/27/7367092f0d5530207e049afc76b167998dca2478a5c004018cf07e8a5653/mkvtomp4-2.0.tar.gz"
  sha256 "8514aa744963ea682e6a5c4b3cfab14c03346bfc78194c3cdc8b3a6317902f12"
  license "MIT"
  revision 2
  head "https://github.com/gavinbeatty/mkvtomp4.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "081d9ac327ac15673cc580c72268bab867954cdbf342a2b2f0f8b4d6c5a0e935" => :big_sur
    sha256 "8a0cfe2a1c9cb72fa3cf450d2d9ef6bf0f3166802e86e6854dbc6de4d079e3c6" => :catalina
    sha256 "694911a5ed4c147120d1f9eae4bd608390ab09d5e05123ce5d1129c216826010" => :mojave
  end

  depends_on "ffmpeg"
  depends_on "gpac"
  depends_on "mkvtoolnix"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    bin.install_symlink bin/"mkvtomp4.py" => "mkvtomp4"
    prefix.install libexec/"share"
  end

  test do
    system "#{bin}/mkvtomp4", "--help"
  end
end
