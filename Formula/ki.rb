class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d7100140e57f1c3a3c44bab2435dcd80fe04db756c9a8e72c726c0b36ad5767d"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e9f0d1372315b5518bbc05dab3e5a2ee749c68ea59c0c5f1f31b276db8c33a2"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb557d13c281da2852c117922d63673ca76f4337bb2328b8b7a5b092836546cb"
    sha256 cellar: :any_skip_relocation, catalina:      "2fa5ab29776d2d12f81731dd5c89e9416cb44812db796b0fe421b33ae31622cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f960a850d909a38a77c18c2088ec442a65f47dd22d4e53b45d93906279459a"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki", java_version: "11"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
