class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.3.5.tar.gz"
  sha256 "f871dee8b3f3ab2d6d69104030ef1e9e2c10d8c8be7d3cfa57607fcfb2959046"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29040c6264a9efff18fec124851642631ab10e00c397b59de052e689284cb18e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51346c2e14f0ee7b768567e9678ad767fb10bec5659364d137ba8d7f848fa92c"
    sha256 cellar: :any_skip_relocation, monterey:       "86eedf0a7397e6841d939353c75e6261fe6a991365334ea7bb9e89095e0e825b"
    sha256 cellar: :any_skip_relocation, big_sur:        "489375fb1ba3fd9de53a0f42759b1eae2b43f694a7331f9e0d8a929701e59034"
    sha256 cellar: :any_skip_relocation, catalina:       "1a8b065e047b8e391adbabae2972d43e9a5cbde7bee4a43719a5cc469fe3683b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf617fed90382bf2f27c1b9e58d302cc8355309a9f7bc62f84ced9d2f37fc346"
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
