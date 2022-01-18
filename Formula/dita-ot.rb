class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https://www.dita-ot.org/"
  url "https://github.com/dita-ot/dita-ot/releases/download/3.7/dita-ot-3.7.zip"
  sha256 "dbbc9f8dfea51300e707307b5d65e7945b9357d5fa2d484fbb9264268771abc7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3384723dcd29df9d1b8347af6d825d1b101dc163f1003c198c814e4c83da671d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3384723dcd29df9d1b8347af6d825d1b101dc163f1003c198c814e4c83da671d"
    sha256 cellar: :any_skip_relocation, monterey:       "2d09359ab97ecc2dafd95b1b429ccd272304f3871d2e257855d8be0076e4393e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d09359ab97ecc2dafd95b1b429ccd272304f3871d2e257855d8be0076e4393e"
    sha256 cellar: :any_skip_relocation, catalina:       "2d09359ab97ecc2dafd95b1b429ccd272304f3871d2e257855d8be0076e4393e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f6d11d33f4121adc11b6612caf80f44d646a562069bb9b4aa59b2e46cc6680"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat", "config/env.bat", "startcmd.*"]
    libexec.install Dir["*"]
    (bin/"dita").write_env_script libexec/"bin/dita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin/"dita", "--input=#{libexec}/docsrc/site.ditamap",
           "--format=html5", "--output=#{testpath}/out"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
