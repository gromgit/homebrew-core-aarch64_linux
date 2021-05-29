class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.26.tar.gz"
  sha256 "01db9839aa443f4c351324c4150af8b5e06eca95452e6195354c3fcd91a052b3"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea9f44c3ef96c520b2959ced16cbd95afff8c944fde477866f0502189956d668"
    sha256 cellar: :any_skip_relocation, big_sur:       "d583d00bf3b4101899a655a4b8e6654524d43c775043dbbf812f760ad49c3490"
    sha256 cellar: :any_skip_relocation, catalina:      "e8992c52a8cb4afe7292fb7e0d8444cca091bd04cde13cd19a6ab14211c5e0ad"
    sha256 cellar: :any_skip_relocation, mojave:        "33ce62de14cd6c5a5d8d153c5048645180206221278e2b347b71450acdec57cd"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.0
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
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
