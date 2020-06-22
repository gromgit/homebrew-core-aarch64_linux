class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.1.3/pdftk-v3.1.3.tar.gz"
  sha256 "d9145976adf2dd5f8cd70e1e2345262e46790be6bfb2da1728a2ad4f6e4b2021"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5f0aa0254d46f621c2639ec6586195e648f48429e4bcace507116419ac4e086" => :catalina
    sha256 "0ab7caaa273b91e57bf35a229f5278cad08d74265fb7f34c436539900f788018" => :mojave
    sha256 "30a6f07b82b28c7b40144693d6a862e5992df1386dde4641df2fdf66da086dbf" => :high_sierra
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
