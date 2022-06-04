class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.4.tar.gz"
  sha256 "6da8b7d57e1db5953a502cd8fbf3dd2e34e8fee6800c33f4d41bf18876cd36e6"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2237e7a597de2c7ebf5e2906b2583375a6813bed67c9d6f60bcbb8908a3bd6ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d65b5064ad6bc5ca25869a108986eafeec38a62bdf90505283d6311c30afbb59"
    sha256 cellar: :any_skip_relocation, monterey:       "adad8473e6f77c07be36d20ce37e187535c5b395c518f3435849536ed33d3643"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e1a0a9cb274bb1e8b65c67c86287ae509dc83c0c449a0918bdcc8f1fefd1d28"
    sha256 cellar: :any_skip_relocation, catalina:       "4389899d6ef72d5a8a861916d31445444f62f88363d7efff71cae26d38807ddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c341a70bc4a073cc8b79274ab53c128d3f90e4bb04da82fa0d2b37222939798"
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
