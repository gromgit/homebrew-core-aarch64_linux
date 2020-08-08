class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.125.5.tar.gz"
  sha256 "035421e02ace98f8b3aa29dcbb52fca96c8067ba8df2c3ab26423a1b6fa5f54b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "32ad4a4e33ea55f466bbade2d3d92b4c4eeb80cbc662027bcfeaf12e1fb5b778" => :catalina
    sha256 "0ba3017a27ee46134bc84c399b5241bfff51297f76868b09f617a898f89c92e2" => :mojave
    sha256 "552195c4edcd45ce92d611a9807b720dc1f566783805f8027e522f8e33a5ec70" => :high_sierra
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
