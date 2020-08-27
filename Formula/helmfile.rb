class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.125.8.tar.gz"
  sha256 "cd0da88b4be3aeee9f2d4f5613ac946a985bf7c627c78f5360b9e3b01686443e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d02b676d8bc23a4f9f54dafcf7d94268d258c8a5f311e1dcac1ff42567c8c0a8" => :catalina
    sha256 "13881a0d3ac260a2419cc38cd332884b45112af120f3ebda72f5f34129f4e4dc" => :mojave
    sha256 "c24bfd38c187158d13b90f9a8797381e75294d1a849e1b4fe892ed5c5b5112f5" => :high_sierra
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
