class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.125.4.tar.gz"
  sha256 "395809d0a3f2ace382d8d9af9c17945339081adbdcb32f05c294caefe04c1a7c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "905e9774ed653820f3cfd1e8d31a6eb2783ddf63e45d4f35cc30850b9338b043" => :catalina
    sha256 "a13bd8a339c0facf273dedacd067b2ea955484e51ffeb511a9df3b8503d5d4c4" => :mojave
    sha256 "00b63e102fc69b59cf843903b4d56209520ef6204a7ac33e6fcbd29ffb516dbe" => :high_sierra
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
