class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.2.4.tar.gz"
  sha256 "b31e5d179531343e18b3fdb2d2407a5cf18b68606539ceb96a17cdbc60dd12a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5a015746780add045d2b8c11fdc68183570c11453bf5b9217eaa27d05bbede2"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e03d4d317bee5cea82714e47dfa3700ad98391ea7d7500e30ccd480ce2c940d"
    sha256 cellar: :any_skip_relocation, catalina:      "81e59707550375c76d083d2eeef61cde10619b7a5926bbcf66be60d6d93c9982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a69893b308d8ad02bcfe7c62ee0ef029219c892f4c0d140cc417b7b55f99e0d7"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@11"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("11")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
