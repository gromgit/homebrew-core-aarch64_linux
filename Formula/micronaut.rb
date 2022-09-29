class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.7.1.tar.gz"
  sha256 "7e88e95a7e9075b02d2ae9afbdb500f07117b109d7d6cf4fa5965fc91911e302"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d91020a487e9aff95d9c58e7735146b832baff0d91b75f08d5fe9828cd01f5e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31ab37db94cfac5af0550f6be35e6921e57127bbb943d7eb49b61acc5edb8893"
    sha256 cellar: :any_skip_relocation, monterey:       "c68dd8d1522293f72437a2c1b1ea6886d1ced8cbf8f1492e97bf760368142587"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbf4be1f9fe8fba96885fae6e327d69526f2f1c4a46932c51f99200a8ac63eb7"
    sha256 cellar: :any_skip_relocation, catalina:       "a9fb84e2297d4c809f0d56d76df9621d91eff4e4b33e2e98d1e8ad68420dbd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbce18464333627b7559300f642823a11a539137693c7281f12b6683ce7bf212"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@17"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
