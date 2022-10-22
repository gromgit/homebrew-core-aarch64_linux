class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.17.1/liquibase-4.17.1.tar.gz"
  sha256 "1dc4b6ba8406a6c229984e287d0fb106ae2a29ac667a22628d8217ee8dbaa381"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.org/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eed708873e5b17ab2b5b17ff4e3ec84fb58936a57221f9846b83807b035befbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eed708873e5b17ab2b5b17ff4e3ec84fb58936a57221f9846b83807b035befbd"
    sha256 cellar: :any_skip_relocation, monterey:       "57df05faf2f1d433f81e2fd9c5afb3998782b07a41e0d83e8606b809c98d01b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "57df05faf2f1d433f81e2fd9c5afb3998782b07a41e0d83e8606b809c98d01b8"
    sha256 cellar: :any_skip_relocation, catalina:       "57df05faf2f1d433f81e2fd9c5afb3998782b07a41e0d83e8606b809c98d01b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eed708873e5b17ab2b5b17ff4e3ec84fb58936a57221f9846b83807b035befbd"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    chmod 0755, "liquibase"
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"liquibase").write_env_script libexec/"liquibase", Language::Java.overridable_java_home_env
    (libexec/"lib").install_symlink Dir["#{libexec}/sdk/lib-sdk/slf4j*"]
  end

  def caveats
    <<~EOS
      You should set the environment variable LIQUIBASE_HOME to
        #{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/liquibase", "--version"
  end
end
