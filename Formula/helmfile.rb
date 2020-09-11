class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.128.2.tar.gz"
  sha256 "de70a969fbde6e6799612170aaa05f24567fb5990170878bba38126fc10797c4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0e3e6946ed9ae9e66c3e8d696d807b37bc24f103e413175c9a075cd991dbd1d" => :catalina
    sha256 "187a63543c16b654ce0749080f4b411ee172072e465710213c141da15089c48f" => :mojave
    sha256 "1fdb26b24c9a7da1427ff89d5deda6b063573b5ee107a2d081924297d06fefbb" => :high_sierra
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
