class Fantom < Formula
  desc "Object oriented, portable programming language"
  homepage "https://fantom.org/"
  url "https://github.com/fantom-lang/fantom/releases/download/v1.0.78/fantom-1.0.78.zip"
  sha256 "be6b9688177e5dd4087591ec89ac1d6faf1effa482d0ccc0315a991c4d66343a"
  license "AFL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fantom"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "69768b0d678c7131355d5edc26126a02061407c725c3d8831f8b6651631f5ad9"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.exe", "bin/*.dll", "lib/dotnet/*"]

    # Select OpenJDK path in the config file
    java_home = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    inreplace "etc/build/config.props", %r{//jdkHome=/System.*$}, "jdkHome=#{java_home}"

    libexec.install Dir["*"]
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: java_home
  end

  test do
    (testpath/"test.fan").write <<~EOS
      class ATest {
        static Void main() { echo("a test") }
      }
    EOS

    assert_match "a test", shell_output("#{bin}/fan test.fan").chomp
  end
end
