class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/9a/20/62b5e9bcdf74e26a5b3628fe504a4b2542ee21ac1df2e66fc10c66bfa4c2/gallery_dl-1.22.4.tar.gz"
  sha256 "7496f385940868c05755ddabe3417f7d97e89244aaf29552b11af29b1ac8ca79"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2419be9d2332acef4d56c753d69b75d33a5f63e83e01753e55e35c43057bdd28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "514bfd353eba136cdc36f2d53f57389ffde4aaddc23c33a66c1a0866b0421b53"
    sha256 cellar: :any_skip_relocation, monterey:       "5bc70aa9ac01711c22fdd2f0d153b40850f875ebb72ad0275fcabde1b7f74389"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd24ea11764f9beecb85dac2819669ae297b89790be2730edf6a3ebdcd4e61d2"
    sha256 cellar: :any_skip_relocation, catalina:       "caeed6f7080257ca39dd31e6f364976c742ed2e50292ea59b33608d6b9907dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94b6f9acd8c979d6f6914894afed5b7f28bf0031b36fd525475ab2b16bc64171"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
