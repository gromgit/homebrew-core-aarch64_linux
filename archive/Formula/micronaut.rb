class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.4.3.tar.gz"
  sha256 "b313e41e1cbffb52e79927dcc8993d319d040f8c648643f455aa3403ad6eee89"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4b71fa57a18c2d622a9ed9b67444b224155b0e76e5ceba4d1b62eb3f6c08f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a987f1f3bddf6534a3dce17ad2bd16ca35f489e1ede1c6d0453e6bb698e5b759"
    sha256 cellar: :any_skip_relocation, monterey:       "e4da42ef57d97f7ef6e4fd6cb543b332e96eaee49c3cb29351da103d8a8872f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "db4e3e3fab0dccdcfeff2980df9d00d09dd4bedbf1253c9905297cd9b1eda86d"
    sha256 cellar: :any_skip_relocation, catalina:       "177fdadf524feb1b573f2df0eed296c665cc0a89901117b3b7f3675d7af24fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9da1bf374de65c431ad852dbf2760c820bca01d2c99e45e25ac0043d69a6362"
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
