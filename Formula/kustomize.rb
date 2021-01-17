class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v3.9.2",
      revision: "e98eada7365fc564c9aba392e954f306a9cbf1dd"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git"

  livecheck do
    url :head
    regex(%r{kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b4c961f78d27562655fac7e3f1c611e77692c7c68d56f7da0bdc59b4605c7100" => :big_sur
    sha256 "48ef55519e8c3d1cb2175e3905b3b2e4045a7b9955b70342b208d48690c5588e" => :arm64_big_sur
    sha256 "445f6f2aa0abe3b760d9fab744ff7642c8f2fd5492dd41f01f6945e647f9afb1" => :catalina
    sha256 "4722f5144260b06f94a2886eb14fdcb9114e744a78f5fe21be60b45623b75c9b" => :mojave
  end

  depends_on "go" => :build

  def install
    tag = Utils.safe_popen_read("git", "tag", "--contains", "HEAD").strip

    cd "kustomize" do
      ldflags = %W[
        -s
        -X sigs.k8s.io/kustomize/api/provenance.version=#{tag}
        -X sigs.k8s.io/kustomize/api/provenance.gitCommit=#{Utils.git_head}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{Time.now.iso8601}
      ]
      system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"kustomize"
    end
  end

  test do
    assert_match "kustomize/v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patchesStrategicMerge:
      - patch.yaml
    EOS
    (testpath/"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match /type:\s+"?LoadBalancer"?/, output
  end
end
