class Helmfile < Formula
  desc "Deploy Kubernetes Helm Charts"
  homepage "https://github.com/helmfile/helmfile"
  url "https://github.com/helmfile/helmfile/archive/v0.146.0.tar.gz"
  sha256 "c61f9efb150793a253660000fa929b0a87552b66bb2a27373f39e93d54ade932"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62ffa93cde7b240eea524c0363fd6da5cfaa42e51e568e3d7b027172731a5903"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddce4fd018ad255a29b4227e62210cb76a269287bd7ffaa8ac665488f438959a"
    sha256 cellar: :any_skip_relocation, monterey:       "05f1095a28f9e118d3f86a17f3f0d83c76293866da67d1c5adf3ca84299d05cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "153f07a035f776cfdabc2cfd3ba00bb7b90dba0a7101a31c0678235007f7a25e"
    sha256 cellar: :any_skip_relocation, catalina:       "8c312d93a6bfefa016eba2bad9eb7f2e2a7a897009034a1593393fa9093e2d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c5962105f341a4cca227c912a677e8109783bbbda6390a25c117291619d55a"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = %W[
      -s -w
      -X github.com/helmfile/helmfile/pkg/app/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"helmfile", "completion")
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
