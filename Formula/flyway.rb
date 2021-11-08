class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/8.0.3/flyway-commandline-8.0.3.tar.gz"
  sha256 "f68e94f830b747bdb5c7c8daaec18980a2c5473253cef4d913e0f8c79220ec13"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823df6476a168a995f0d61c08a95293bb972431a35584befe480a676fe0d769c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "823df6476a168a995f0d61c08a95293bb972431a35584befe480a676fe0d769c"
    sha256 cellar: :any_skip_relocation, monterey:       "823df6476a168a995f0d61c08a95293bb972431a35584befe480a676fe0d769c"
    sha256 cellar: :any_skip_relocation, big_sur:        "823df6476a168a995f0d61c08a95293bb972431a35584befe480a676fe0d769c"
    sha256 cellar: :any_skip_relocation, catalina:       "823df6476a168a995f0d61c08a95293bb972431a35584befe480a676fe0d769c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823df6476a168a995f0d61c08a95293bb972431a35584befe480a676fe0d769c"
  end

  depends_on "openjdk"

  def install
    rm Dir["*.cmd"]
    chmod "g+x", "flyway"
    libexec.install Dir["*"]
    (bin/"flyway").write_env_script libexec/"flyway", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system "#{bin}/flyway", "-url=jdbc:h2:mem:flywaydb", "validate"
  end
end
