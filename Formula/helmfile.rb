class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.122.1.tar.gz"
  sha256 "cfe247cf046562cb30b7ed2ad4764458d1066f9c082fcff6453ac78ec40b1e6c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ea8d9caf7a9c19dfa6d9f9b8d19922e329683e3415f37e1edca788e3e68b39d" => :catalina
    sha256 "8cb1a9f035c837b80b30ccde1b3ccae1f8eb252d5237acb41493b9e265762a9e" => :mojave
    sha256 "b0afd388b2c572855eddfdce5114fb545a423678fa95c4bdcdbdd6136856adb6" => :high_sierra
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
