class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://github.com/micronaut-projects/micronaut-starter/archive/v2.2.3.tar.gz"
  sha256 "ebe3cfd4481b55cb6e0d77c0a0e9337b0a9ceea6b6089e2cd742f037675b6369"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "095a4fd5e8858dbe0a3fa873015ee08d80ffa96feb47a4e133fd9690baffe5e2" => :big_sur
    sha256 "0707d528ceee48aac9031da0c1c5b2a30f09b59070ef2af71fd15e2ae9d5a317" => :catalina
    sha256 "12e74a3d126f557c3144a64bef0499e46f50bb2532ad0a79a4a9b3a0bfe29ded" => :mojave
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end
