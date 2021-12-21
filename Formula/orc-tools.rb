class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.7.2/orc-tools-1.7.2-uber.jar"
  sha256 "abaad645670eaf34592a76c7afc5f34ac1f85a559e3f77943f3f97608b194c51"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "344befd82f662ab9e02ddfeaef419d27a6a1c91d5602dca8d4f9335f06f14148"
  end

  depends_on "openjdk"

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system "#{bin}/orc-tools", "meta", "-h"
  end
end
