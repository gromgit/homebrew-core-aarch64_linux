class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.6.0.tar.gz"
  sha256 "98b9cd8c7cd3a75b4199b6872b4dfccc025af87cfc9568c2b23eaf523dfed72a"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "308b4f20e81dcee120b91369b01fad77d83960e088db324c8dfadcea7c3a56b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85601fe79e4671160ab8146d20500b4ea0e12c06c64f8e97ef298d1db206fee9"
    sha256 cellar: :any_skip_relocation, monterey:       "081167d9a44d3d4bf2cd9cf5646dd6f463c0e6385472a42d5d4163d143019a99"
    sha256 cellar: :any_skip_relocation, big_sur:        "6020e7575fa062164ddbc62e65a17f2ce7ef570870ad18799ba1415399d82906"
    sha256 cellar: :any_skip_relocation, catalina:       "17421fff473c24c5936ff4bad9d6010b8aad664a2e4b8b0ea0dbcabd55f608d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c742779ab845c34535d08dd377392a1ddeb486d671b168c7c0bae9f4ad7a6ece"
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
