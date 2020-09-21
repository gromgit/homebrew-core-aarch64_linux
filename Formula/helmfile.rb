class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.130.0.tar.gz"
  sha256 "233b82ed7670caa08c8056f27f972d1bc389c319b551c2ab5d12241284cf502b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "79c23f440ddd6e31ede6f4b01b5ffc5e6a0c79afd36a4dcb66fe2165137da2b4" => :catalina
    sha256 "4606508b9ae9e5d3b44380d4253603ff89bcdc9fac98c6dad02b3f0df7da2176" => :mojave
    sha256 "86a81a90fdb48afaeee8a9bb6e1089a1097097beba4be7d76d1ba9fa3411c38d" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", "-ldflags", "-X github.com/roboll/helmfile/pkg/app/version.Version=v#{version}",
             "-o", bin/"helmfile", "-v", "github.com/roboll/helmfile"
  end

  test do
    (testpath/"helmfile.yaml").write <<-EOS
    repositories:
    - name: stable
      url: https://kubernetes-charts.storage.googleapis.com

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      createNamespace: true                  # helm 3.2+ automatically create release namespace (default true)
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: stable/vault                    # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
