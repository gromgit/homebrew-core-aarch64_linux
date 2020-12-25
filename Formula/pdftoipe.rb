class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    cellar :any
    sha256 "956ef88756235f6f7eda7e35eb95bd1c0ca7c1340df2ccfa169ca6a6a57da534" => :big_sur
    sha256 "c9025d74ab88c1c9496e17b6edde335d713b8ccc58cac6a82da86ffb45ce068d" => :catalina
    sha256 "b841d1cbaf563f2c00b564acc582430b46b56381087d1926c258efcb7a600593" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    ENV.cxx11

    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
