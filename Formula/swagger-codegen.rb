class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.31.tar.gz"
  sha256 "70085942d3356aed80c56ea5944f0926b6dc72a4d630d0cd3ddd54fab41c56ce"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1e3b8f24aa2b895e9d7dd127e28614ab9e875d20046e6d8f02b225d353807b36"
    sha256 cellar: :any_skip_relocation, big_sur:       "74eedabadfb1825959aaa93b4fabbdc888574e864429309563813c7b23ac5d5c"
    sha256 cellar: :any_skip_relocation, catalina:      "ff7476352c20a12989f287d0058e79593a65a5e3061e226a14682ab75f28bb16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b70fed0f9eef067883ad5d92f3424ef9a5e23bbe4b9f69c885f230a63045cdb0"
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
