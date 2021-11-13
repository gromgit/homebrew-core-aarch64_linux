class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https://spotbugs.github.io/"
  url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/4.5.0/spotbugs-4.5.0.tgz"
  sha256 "327d5e36afa223737e871114e173c6f2d4543e22c6167bc7825001a752a3cf31"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "073f01f87bc1678ecf70d08d368d1c2ca364246a3541763c82f23951d478080e"
    sha256 cellar: :any_skip_relocation, big_sur:       "073f01f87bc1678ecf70d08d368d1c2ca364246a3541763c82f23951d478080e"
    sha256 cellar: :any_skip_relocation, catalina:      "073f01f87bc1678ecf70d08d368d1c2ca364246a3541763c82f23951d478080e"
    sha256 cellar: :any_skip_relocation, mojave:        "073f01f87bc1678ecf70d08d368d1c2ca364246a3541763c82f23951d478080e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef7b7973ca86f296ee764214853dd75f2afb6fc4a2a72f733e88fa8d18e17932"
    sha256 cellar: :any_skip_relocation, all:           "05ab6a72c5617ecc368499f558e82f7843a4b69cc52bed82a8a54476d75b1942"
  end

  head do
    url "https://github.com/spotbugs/spotbugs.git"

    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  conflicts_with "fb-client", because: "both install a `fb` binary"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    if build.head?
      system "gradle", "build"
      system "gradle", "installDist"
      libexec.install Dir["spotbugs/build/install/spotbugs/*"]
    else
      libexec.install Dir["*"]
      chmod 0755, "#{libexec}/bin/spotbugs"
    end
    (bin/"spotbugs").write_env_script "#{libexec}/bin/spotbugs", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      public class HelloWorld {
        private double[] myList;
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
        public double[] getList() {
          return myList;
        }
      }
    EOS
    system Formula["openjdk"].bin/"javac", "HelloWorld.java"
    system Formula["openjdk"].bin/"jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    output = shell_output("#{bin}/spotbugs -textui HelloWorld.jar")
    assert_match(/M V EI.*\nM C UwF.*\n/, output)
  end
end
