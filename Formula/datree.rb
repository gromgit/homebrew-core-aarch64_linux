class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/1.4.30.tar.gz"
  sha256 "8cd4d0f33e204e892450ba3157b94cf7e96c2858559c6fa89ce4a3f40a4913ff"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4042b496a7663009096e938a086050fbe9db4c000f2126cfa4683daca6c5f919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4009416edaeaaaecb17888a586fff2941734e3a46702501b37ffda02c83917e"
    sha256 cellar: :any_skip_relocation, monterey:       "c8ac442feb4eef42ad5b40f2266e1f511eaf544efe03d072524ef4e37773c471"
    sha256 cellar: :any_skip_relocation, big_sur:        "eafe9ba1358cfd6bc5617d84f94d66f28f3edb9af58116b5d98b1c27f0a42a6c"
    sha256 cellar: :any_skip_relocation, catalina:       "4d3390372cce50a4d7febf308b03f8b33637692c8d976ec83122914684716df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35539e41438620603de674b812409ceed8104074aa3cbe33051126892c8a5a4d"
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
