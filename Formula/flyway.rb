class Flyway < Formula
  desc "Database version control to control migrations"
  homepage "https://flywaydb.org/"
  url "https://search.maven.org/remotecontent?filepath=org/flywaydb/flyway-commandline/7.11.2/flyway-commandline-7.11.2.tar.gz"
  sha256 "194dbfa7c2f4a74b264e9477bf5dda73e76b69253555603349ba4a6b9e7bed28"
  license "Apache-2.0"

  livecheck do
    url "https://flywaydb.org/documentation/usage/maven/"
    regex(/&lt;version&gt;.*?v?(\d+(?:\.\d+)+)&lt;/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "7f00af7508b36cbe28e8ff882b70649f8afcc6d1671bf11edb5e7e1d05570a30"
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
