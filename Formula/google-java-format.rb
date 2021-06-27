class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style"
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/releases/download/v1.10.0/google-java-format-1.10.0-all-deps.jar"
  sha256 "9d404cf6fe5f6aa7672693a3301ef2a22016ba540eca5d835be43104b71eb5d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be92665b363b4b564f4182cf25a7ff4eb9a5306b5b95d11ec6bd385613fb4c78"
  end

  depends_on "openjdk"

  def install
    libexec.install "google-java-format-#{version}-all-deps.jar" => "google-java-format.jar"
    bin.write_jar_script libexec / "google-java-format.jar", "google-java-format",
      "--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED \
      --add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED"
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
  end
end
