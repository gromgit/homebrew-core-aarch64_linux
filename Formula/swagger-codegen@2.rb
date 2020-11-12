class SwaggerCodegenAT2 < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v2.4.17.tar.gz"
  sha256 "8dbcd9311b22ca0aa16094fd616e6e6053ee081f06f26a1ae97df5b8e25dbb31"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://github.com/swagger-api/swagger-codegen.git"
    regex(/^v?(2(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "965d3c3b02e64c735b986086d2aceccd5299f18be9cf678be31b8050b3155e78" => :catalina
    sha256 "61f7f065f04bdae2d4a13fb427100e14675fbbe671bbe6d6d43f9dfebd2125cd" => :mojave
    sha256 "e11c4e5349aedc3ce547e163978cde4e2198750350586c28750fac98f76f84c0" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "maven" => :build
  depends_on "openjdk@8"

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
