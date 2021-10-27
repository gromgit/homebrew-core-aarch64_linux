class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://www.datree.io/"
  url "https://github.com/datreeio/datree/archive/0.14.20.tar.gz"
  sha256 "df1fd0c087a03f72bd9524b26b56eb974f07310b844637a8b7e3424bd2da5cd0"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4190bf06285b1db0b583be1cca91a2e9e39295b4c9ed0f78e7bdeb8c1b27244e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37c9c9b7a214e9d176134a50a5e874c3f9c7ef8d5e8e969e47beee71f7e736bb"
    sha256 cellar: :any_skip_relocation, monterey:       "301982bafac0c4958d09ccd2cfe0b14b4c6a8cf8b1c1e3d90c1c9ebcbe6f6442"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f901f3a80b55a0956ae0ac6cd7fe306a53b6b2c12a8696543b42c9c37c8f402"
    sha256 cellar: :any_skip_relocation, catalina:       "22c8471a4d0632a243c1826f5813f1059e1f62725b5407cdaffbb8cefec8c407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2676a1ac35097d82ad003fa97218a51d861fc3f646a7a8fe6ad1198e6b23fa74"
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
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml 2>&1", 1)

    assert_equal "#{version}\n", shell_output("#{bin}/datree version")
  end
end
