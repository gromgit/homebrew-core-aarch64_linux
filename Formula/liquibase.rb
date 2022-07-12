class Liquibase < Formula
  desc "Library for database change tracking"
  homepage "https://www.liquibase.org/"
  url "https://github.com/liquibase/liquibase/releases/download/v4.13.0/liquibase-4.13.0.tar.gz"
  sha256 "fa8567be12ad88346f0907e68c412b5c77b26b1cb3964c2ccdbe5f9e98ad2461"
  license "Apache-2.0"

  livecheck do
    url "https://www.liquibase.org/download"
    regex(/href=.*?liquibase[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da07760c2b5ced7030d97afb5f7a4987da7758f5d688038bb1e7346f56cb6c5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da07760c2b5ced7030d97afb5f7a4987da7758f5d688038bb1e7346f56cb6c5f"
    sha256 cellar: :any_skip_relocation, monterey:       "538734ff063f40d6913199b0fc91b59ec919654c509b45c93e2e25f3b5c6d311"
    sha256 cellar: :any_skip_relocation, big_sur:        "538734ff063f40d6913199b0fc91b59ec919654c509b45c93e2e25f3b5c6d311"
    sha256 cellar: :any_skip_relocation, catalina:       "538734ff063f40d6913199b0fc91b59ec919654c509b45c93e2e25f3b5c6d311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da07760c2b5ced7030d97afb5f7a4987da7758f5d688038bb1e7346f56cb6c5f"
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
