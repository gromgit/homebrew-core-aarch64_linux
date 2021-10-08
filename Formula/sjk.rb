class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.20/sjk-plus-0.20.jar"
  sha256 "c10aeb794137aebc1f38de0a627aaed270fc545026de216d36b8befb6c31d860"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2bc1c9dadeff20643d36e42a6f018a80c6df288fa5e3bbaf557b611007142b14"
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
