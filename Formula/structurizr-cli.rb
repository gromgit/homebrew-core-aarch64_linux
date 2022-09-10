class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.20.1/structurizr-cli-1.20.1.zip"
  sha256 "6ba9133243e1780200042c030760b56ca89ca802673a0618726419522c82be8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1af144e2697850f9e00da435caf9760d6769b602fbb8db93b60b254f8cfdf8f2"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    # not checking `Structurizr DSL` version as it is different binary
    assert_match "Structurizr CLI v#{version}", result
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list [options]", result
  end
end
