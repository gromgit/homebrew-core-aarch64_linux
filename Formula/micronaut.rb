class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v3.5.4.tar.gz"
  sha256 "708cebf8eccf6d1a62c8758f0298dc1d772d2ed791d8608c1171ac198c1898a3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7ce458c9b0a87431b7fd722302cbf0b6d844598c66212686baa7685469585fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f0960379f8746eef8114a64510b88dd70b041a7c055d6c79b88dc1fa8b4cd95"
    sha256 cellar: :any_skip_relocation, monterey:       "d8c1b292a21ead1bcbbc2b48a596eed1bae3e6505f0e01d219989365ae04f87a"
    sha256 cellar: :any_skip_relocation, big_sur:        "338d55596442c5e947bcd03bc84fc382ce6ff32405b51c4a51c5e2b461cee246"
    sha256 cellar: :any_skip_relocation, catalina:       "652c36d809e9dbbed7d50a43234a7ad496d5a0980923c70fe9af6777d1ab2399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d1385f12115a894e593c01e1338c5ea3a8ed40489b1887939d63c020ec9ac0b"
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
