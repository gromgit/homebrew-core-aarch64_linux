class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.13.tar.gz"
  sha256 "4e77610e01a17352dbf065aeb493780cfcbd7d82296c2ef41eb48129567aa605"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a72c4a19e54ac5c7d89889fd40b527f032c8d30c8db74dedb4d23d4d380ce3c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97a9ae868b38534805c7e8370c6888863ab610f9e336633d3172a3456391b3eb"
    sha256 cellar: :any_skip_relocation, monterey:       "c4611e35834c6226ca55fee4c465b231a63f571677108ad3d73b50ea029cf75f"
    sha256 cellar: :any_skip_relocation, big_sur:        "63ddc3f79fa9486d468b6d09f4d422567581e42613adce6376ff5dcdd33aa475"
    sha256 cellar: :any_skip_relocation, catalina:       "fc02ab7939d0cafa4dc266d37dacf67047a867ce620baf0da1e264183d7665d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cdf57f3cecafd7d566e7f79563b8e205d605592eb3d67da08d55dd16061a076"
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
