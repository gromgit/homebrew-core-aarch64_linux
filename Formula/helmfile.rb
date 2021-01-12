class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.137.0.tar.gz"
  sha256 "233fc11612d79b5170db579e8f364caa53e311c585901223996d4f7fcb511837"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e421014d140580407bfb9f5b6ff20ace401938210a18e6039936f0b035eb28a9" => :big_sur
    sha256 "c8ee851f74abb86568857c5083a02cb71654304513590560fa4b63b22f9662bd" => :arm64_big_sur
    sha256 "a687d871e242d4157abf6271ab49b5e61d4fd10bb28d0f9a2044a2af54651142" => :catalina
    sha256 "0c1e8e5438ea509d3a1f7788d324e2a8c3c284bf0a7ac5223def5c6f7b474247" => :mojave
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
