class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.125.0.tar.gz"
  sha256 "14ff7dd0004d19318e88d407af8d11da5f8d73755171473250a23fce9cd93e6a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "20309cae42e4f7326527539b9803a8ebad2076efb70ff93a8543d343a2c8f1cf" => :catalina
    sha256 "82e544dcc1fe76f1b439a4156307fe4b37614e2051aab4f6ff7f44f78df4ad9a" => :mojave
    sha256 "e93efc43348b5554f653b6dfe41ff854be5cba5959ef9a09407c4c0fe0fe8fd8" => :high_sierra
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
