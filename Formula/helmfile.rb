class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.132.0.tar.gz"
  sha256 "9309c48b8a737bc90eb8ffd4a660c320a55336808fc196225ae33f10417a7f45"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6798bdc5557a155a286337a787aa48160809d639180d2c0f5af9a276ef03294b" => :catalina
    sha256 "c8815258f21eebb6e7cf69cc252dafce2d36721fba1dc495f7fcbf2c7786aade" => :mojave
    sha256 "9f83b2123f7b2b0f5d4ea6a8220de4c604c0cbb7e45ded710ddad7a6eef0a828" => :high_sierra
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
