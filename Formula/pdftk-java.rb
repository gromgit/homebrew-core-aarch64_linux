class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.2.2/pdftk-v3.2.2.tar.gz"
  sha256 "b284e413dd43fe440152360eccbc5cb9ffd8978be8313ffc060bfebb74d14bf1"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/pdftk-java/pdftk.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f2aa6eb761ddb5545c5e9a7a9ba70897cc2bbd5b34452b09f3b2109c1995dbb"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c5eac7d61680315e0c8703ab773e92d3fb853eb503f253255d74181339774e9"
    sha256 cellar: :any_skip_relocation, catalina:      "571eeb04b204f29d5cc95d171cddf42e0552e172a72f15fa184d88e7a0562db2"
    sha256 cellar: :any_skip_relocation, mojave:        "c644631818f5515f3e9bb175119f3ec3b9a3344214cb6dc899081269dc6bc809"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
