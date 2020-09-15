class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.129.3.tar.gz"
  sha256 "9640420fc1f23e21dde3e68e651d5e5473444b96d85d6565b114a1e01729be49"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "95a61983c4b7de18f765ce41afb420c58a660db3a41501250817b9500e1ac073" => :catalina
    sha256 "e47a8bcca5bf18de6d622f49a8cdec106120a6521f891b7efe2aa0226a12fed0" => :mojave
    sha256 "3237ad6012f0f4996cab27575385d8f9848d7c9355b1cc7c9e055aa82ec5e0c7" => :high_sierra
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
