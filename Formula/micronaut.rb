class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.5.1.tar.gz"
  sha256 "7ba41abb768021f108d2b244a85fc419ea84e11098a0492971d0ac144eee4cd9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "058341c7fb540b0f70894bde227c383e60ce7c8ea286430259d68c21707a2060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "058341c7fb540b0f70894bde227c383e60ce7c8ea286430259d68c21707a2060"
    sha256 cellar: :any_skip_relocation, monterey:       "4302ea753ef58dab542072d470c1c24048c96dd79c2b063bd6627f87d17eded9"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfa155ea0068229808a5f733f3028712434fa264f8bc2420864b60bec0111c25"
    sha256 cellar: :any_skip_relocation, catalina:       "f789cbe9ae76764817cc80e117184f2d9d535078d88d3b817bd369ac3a62c98a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a476754202d604c494273fb68d19f75e4159ff9d0bf45bc7e8719540d863b6"
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
