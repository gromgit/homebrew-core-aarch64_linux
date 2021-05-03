class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c54d66d8475f078c9ab51fd0d0ce140c581072d4b107c5fb4de15c4ac7c9b05e"
    sha256 cellar: :any, big_sur:       "4d4ef2a27b6a87242238380d37fdb228ba3d77e0aba0ab085850844588d8d618"
    sha256 cellar: :any, catalina:      "80d7de3d886fca532162dd265dbc121eea9b3e6c9a989a848048c4165e40ed0a"
    sha256 cellar: :any, mojave:        "1a7aaad3dd9a5d77c4b5c24b9fb50b281f7cad9249c356abf414e194269fc20d"
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
