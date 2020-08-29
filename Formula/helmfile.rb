class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.126.0.tar.gz"
  sha256 "27685511d0f38ab77f229783f2692ce0d1e32c355a08084f0a079c4dac64f2bc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "90adf69bd94915d1482da95d111f8f51c9ddfde0cbbb40c3586b4b04cc9d78da" => :catalina
    sha256 "368e116f645cf5b4c036a78e378c04426ac00fba726415dcbc2da155f676569d" => :mojave
    sha256 "3ed7aa7c195bc820c52186040ecd68b1a95a0acc1c21ef9ff7407294d4fb7677" => :high_sierra
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
