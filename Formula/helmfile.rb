class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.135.0.tar.gz"
  sha256 "c704aef4347b2a735ec9ebc2757ce875e1c8feca0a45b5ab4a30d279bd69443b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "313d45cabcfc898bca705741ef97d69071c8fd41733e9b35d77b12204a4a6a0e" => :big_sur
    sha256 "47ddfec94dd20f1a3736cae78302897ef19ebeb8a89c362aac805f5dde49b07f" => :catalina
    sha256 "b582da32b286937867b1edea456c3791520156923a0e3aed56b94540ad927440" => :mojave
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
