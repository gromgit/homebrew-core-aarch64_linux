class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.0.10/pdftk-v3.0.10.tar.gz"
  sha256 "c540c99772f87bced20b767c318c117fc9cdadeb3d82c50e92ba2bb130717c23"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df1c38be2da451396a1e3ce339af05ac0bd35ac79560fe15c9291aa8bce2195e" => :catalina
    sha256 "4c721a1b76a84f66fc355dd257767f509ea3d692a3dabca1075018d188603061" => :mojave
    sha256 "12ad5a46c0b76e94bb19130940bdf8cef0102d65e46278358fbc40f711fafcd4" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on :java => "1.8"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", :java_version => "1.8"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
