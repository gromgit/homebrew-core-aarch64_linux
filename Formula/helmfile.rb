class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/roboll/helmfile"
  url "https://github.com/roboll/helmfile/archive/v0.139.8.tar.gz"
  sha256 "0477f15aa46528fcc91183711574ec94b95e6f3aa685a98ff4b1ced795fe2514"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f07ecd30667fbe473d067a25e03af5bca5e7b88e56fde19326a56be2b5d32bb7"
    sha256 cellar: :any_skip_relocation, big_sur:       "3fd718646cd00170a23e9dfb17ee02c90c68586138385232e3a04e6bcfba8880"
    sha256 cellar: :any_skip_relocation, catalina:      "b45499d06ef503dcbf5297d16743606d2530758532df7ad255344e46a4d29852"
    sha256 cellar: :any_skip_relocation, mojave:        "96a99f5d4b79705c203127888c340ff0156f56e172331f35e73cb04f8e38f083"
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
