class Sjk < Formula
  desc "Swiss Java Knife"
  homepage "https://github.com/aragozin/jvm-tools"
  url "https://search.maven.org/remotecontent?filepath=org/gridkit/jvmtool/sjk-plus/0.18/sjk-plus-0.18.jar"
  sha256 "583284174dde91c32acdef01550d376b2e15be8573e5d99007651451f5bc8854"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1aa56b2a96e181fda0435cf56cf29c3338bce6c59ed2402a46dd33762765b88"
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
