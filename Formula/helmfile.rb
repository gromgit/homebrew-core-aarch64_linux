class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.118.7.tar.gz"
  sha256 "758ebdbd40be2b6066d75ec0b7029bc9335162808ae306d04d96f2daa6643ad9"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd6ee729a5c8e7c6ec8a7244a3185442a535bda1cd996589af647e0a03499142" => :catalina
    sha256 "6e56c7701b17c43faab46872d291a501549fc71d3a011dc8f0ace3a0978d0c2b" => :mojave
    sha256 "4d8e6242468d66eaba81bd01fe29cf7e7258088ce5354a943a4b7e899307e6c9" => :high_sierra
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
      url: https://kubernetes-charts.storage.googleapis.com/

    releases:
    - name: vault                            # name of this release
      namespace: vault                       # target namespace
      labels:                                # Arbitrary key value pairs for filtering releases
        foo: bar
      chart: roboll/vault-secret-manager     # the chart being installed to create this release, referenced by `repository/chart` syntax
      version: ~1.24.1                       # the semver of the chart. range constraint is supported
    EOS
    system Formula["helm"].opt_bin/"helm", "create", "foo"
    output = "Adding repo stable https://kubernetes-charts.storage.googleapis.com"
    assert_match output, shell_output("#{bin}/helmfile -f helmfile.yaml repos 2>&1")
    assert_match version.to_s, shell_output("#{bin}/helmfile -v")
  end
end
