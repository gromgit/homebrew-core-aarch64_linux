class Umple < Formula
  desc "Modeling tool/programming language that enables Model-Oriented Programming"
  homepage "https://www.umple.org"
  url "https://github.com/umple/umple/releases/download/v1.30.2/umple-1.30.2.5248.dba0a5744.jar"
  version "1.30.2.5248.dba0a5744"
  sha256 "11523494f9f4f360cce9226ed7f68641aa733fa13d4009f871060f9fe54c6a52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd41188baf2192be2d75e098a45efa7a7d83e7c8a76daad5b059bdff6f859071"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd41188baf2192be2d75e098a45efa7a7d83e7c8a76daad5b059bdff6f859071"
    sha256 cellar: :any_skip_relocation, catalina:      "bd41188baf2192be2d75e098a45efa7a7d83e7c8a76daad5b059bdff6f859071"
    sha256 cellar: :any_skip_relocation, mojave:        "bd41188baf2192be2d75e098a45efa7a7d83e7c8a76daad5b059bdff6f859071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c80a927eb6c67b19974ded86bca1daca1e2ad6d41e6e0a5c56b8f2e409b89730"
  end

  depends_on "ant"
  depends_on "ant-contrib"
  depends_on "openjdk"

  def install
    libexec.install "umple-#{version}.jar"
    bin.write_jar_script libexec/"umple-#{version}.jar", "umple"
  end

  test do
    (testpath/"test.ump").write("class X{ a; }")
    system "#{bin}/umple", "test.ump", "-c", "-"
    assert_predicate testpath/"X.java", :exist?
    assert_predicate testpath/"X.class", :exist?
  end
end
