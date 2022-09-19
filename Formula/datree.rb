class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.33.tar.gz"
  sha256 "54c9085ca42a18b4a17df8a5897ed3456a71f4a7f0accedfc0284cedbdb323d1"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5decf1e29bde01fb5b903bc0a920e00c624a95657e507b03e088153e36dab3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ed3b3de642153978b72671ca7efac6a9d3137517e7d68cad7a08501a079c1dd"
    sha256 cellar: :any_skip_relocation, monterey:       "dd16adf16d97bcf5fa4fa6cfdc29d7f89534932520dd445aacc71e19fa30444f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba196f41d3d4a9914eafc6517e3414285b9a7353c4c456e7d02f00ba49b0834e"
    sha256 cellar: :any_skip_relocation, catalina:       "6e01c8460a683d91f89961829421e2b10393aae459e38335711c46b86649cca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70a92bde0f008be4d3f16a4bc1fd8df676f146e46783bedb7a664b3348376d61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end
