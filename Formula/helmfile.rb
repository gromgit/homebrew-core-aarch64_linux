class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.129.2.tar.gz"
  sha256 "3e2de794c274818f9f2db11e2c660db78c4a88b8796ebe209bda6f28a50bb36d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "721b38cb84df0c14b325fcca1e83ceba9eeb83ebf8bb5dc8ac4880e2135821de" => :catalina
    sha256 "c3d3b0f93457abb4bdb9c4a12237318e541ee107731f5d5f038e0c8365a0d142" => :mojave
    sha256 "5fe83e795ff4ad3f483ef44f783dedf685b0114453807fd6a9295fa49e2fbc12" => :high_sierra
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
