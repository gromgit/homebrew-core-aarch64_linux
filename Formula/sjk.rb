class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.18/sjk-plus-0.18.jar"
  sha256 "583284174dde91c32acdef01550d376b2e15be8573e5d99007651451f5bc8854"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c59ab026f8a809a25156e0acf7bcb487439d842e5dc8426a39d01a01a1744511"
  end

  depends_on "openjdk"

  def install
    libexec.install "sjk-plus-#{version}.jar"
    bin.write_jar_script libexec/"sjk-plus-#{version}.jar", "sjk"
  end

  test do
    system bin/"sjk", "jps"
  end
end
