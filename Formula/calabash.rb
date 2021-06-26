class Calabash < Formula
  desc "XProc (XML Pipeline Language) implementation"
  homepage "https://xmlcalabash.com/"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.3.1-100/xmlcalabash-1.3.1-100.zip"
  sha256 "dba453614011bb45b1b85b875d8da9642e7c9ed6d42f78e9963aee5485f3ff8d"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ab946c9278a65a4fb2af46869d933ca372e8c6ce9ce73ab85326816f31d92fa"
  end

  depends_on "openjdk"
  depends_on "saxon"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"xmlcalabash-#{version}.jar", "calabash", "-Xmx1024m"
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
