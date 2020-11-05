class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.133.0.tar.gz"
  sha256 "d21935db77226c3bf03f51ce4d3ab51d1709b0c6c75f288a2d0ee59f5e834791"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1097da1ecbe205efa54bc82b5c6d0d9e61f6ff6d00acdf9d5371f6aa147ed1b" => :catalina
    sha256 "be5084a7eb40b332e9413f7c2bcfdf7d91d0111c55fc61f574eb700bac24846f" => :mojave
    sha256 "ff297f4a26399e22b09348921a89b914a9296577222c88e52b33e5b97d242062" => :high_sierra
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
      url: https://charts.helm.sh/stable

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
    output = "Adding repo stable https://charts.helm.sh/stable"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
