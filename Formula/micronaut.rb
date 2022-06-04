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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "992481f5cc9797cf8bdd170615d4789db6f0ed68e13c8029f2f584bce5122210"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7613bbd9445cd7be15bb116602a5427b6ff6bd4be20d237ab2b16e27ae1ab32e"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b8f81802c82716b03cca832b7c58338e430288c014fbb0886aae944f16c5e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "549b9d2908db1b295a7f8d0efeb13bd7ac695ed452f06b8600136747dbc420ad"
    sha256 cellar: :any_skip_relocation, catalina:       "fbd4906719a791913b626d78bc9bad98dfbd433d3f79a0249b23a43465f2c54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55463def635cbac71b106dd07efb119744e7d8837ecfa52481987a8823fd9e5d"
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
