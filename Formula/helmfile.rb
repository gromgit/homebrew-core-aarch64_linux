class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.128.0.tar.gz"
  sha256 "22358eaaa494f9720cc65f9acefd62d741f0b46267533d837be4fd683805a971"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7b7144e297d12f7b4bedcf591c93509499cd68791629e67db38b26863d0dbdb" => :catalina
    sha256 "1c49fdda3e41cf02790eddb762dd3fcfa6c99a5d0bfd1cfcffa218f24f4690a1" => :mojave
    sha256 "64e70e8412b6ae3d581829ec155e4e3dd8c1335c299b37f172a58ae5d8bcdb25" => :high_sierra
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
