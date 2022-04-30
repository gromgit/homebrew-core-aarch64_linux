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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79ad901384d20e7bed10983d2e8c29552e17517b8473b2d83395d196130d8fdc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9cb70f6d9333b4f7f26463a8e0dd86ce207b367b78eb7935f31080d0c5e8347"
    sha256 cellar: :any_skip_relocation, monterey:       "6ff59653c855f689b1eea94376592f7aea0e7c887c2487a497fdaa569a7ef04a"
    sha256 cellar: :any_skip_relocation, big_sur:        "78b3f4e08ef68ff76d66199bfc6c8ded173e4749c94061e40a66e84a1eb689ae"
    sha256 cellar: :any_skip_relocation, catalina:       "6f2c8753d211c8cbf0bbbb2e36efe449b309909eb0333c3646d9e67e6b9fe3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cfbad97875ff2d6e57a703d6a16b86b33b04263e8f8985aefb8fe6dc7a5e719"
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
