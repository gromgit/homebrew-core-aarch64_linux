class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.16.tar.gz"
  sha256 "0b786ad905a512d78374c784acd1874320764adcdcab046d2f7389a2de3663c6"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1b09fee4b398b09d72ef02aa5866d54a831c713bdc8d9869857ac2a2b60c2d56" => :catalina
    sha256 "cd66191ae88cce0a917d4090c37fc31a7b79d0cb388296afa30d08ba206e96b2" => :mojave
    sha256 "2d2b03876c3d8d915e866e497af0a99063e64c68168f511eed40a37107cc4a21" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on java: "1.8"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "1.8"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      swagger: '2.0'
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html2"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
