class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.3.2.tar.gz"
  sha256 "0857317bb45a59f8860db705a71ce4dccd020d8380a63c4a16a79d5735399689"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eac62e571701525153a2095a7e194a347d2390227a6214aaea96df384addc7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b63a4452040d97bf200cc2e2e92bdcea37b89fe84cb4b953fbcd071159fc62b0"
    sha256 cellar: :any_skip_relocation, monterey:       "8ae236d818e88b1216b037baea0660ef5fab18171c9536512ed13282507afd82"
    sha256 cellar: :any_skip_relocation, big_sur:        "b99f32031183e3e21e5587eca6afc3b3b3feb21bcc3628e6ca3e6659b43850b4"
    sha256 cellar: :any_skip_relocation, catalina:       "c2d4d9ff7b509ed484189158a249a354d8979db3ce15b0a9f54833ecf170ce0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27e7a4c535e0a4ffcb92148e917bcfa32513126005a6b6a5e1f1120c10f3a055"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 2)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
