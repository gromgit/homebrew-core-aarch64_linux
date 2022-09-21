class Tfk8s < Formula
  desc "Kubernetes YAML manifests to Terraform HCL converter"
  homepage "https://github.com/jrhouston/tfk8s"
  url "https://github.com/jrhouston/tfk8s/archive/v0.1.7.tar.gz"
  sha256 "02607090e93ed081dc0f926db4ca08cded6b31243977726b8374d435e25beab9"
  license "MIT"
  head "https://github.com/jrhouston/tfk8s.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tfk8s"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d8965da20a6ca7d6828f85c62099433b04555b5d1fc27a6e18850afb20d242a2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.toolVersion=#{version}")
  end

  test do
    (testpath/"input.yml").write <<~EOS
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: test
      data:
        TEST: test
    EOS

    expected = <<~EOS
      resource "kubernetes_manifest" "configmap_test" {
        manifest = {
          "apiVersion" = "v1"
          "data" = {
            "TEST" = "test"
          }
          "kind" = "ConfigMap"
          "metadata" = {
            "name" = "test"
          }
        }
      }
    EOS

    system bin/"tfk8s", "-f", "input.yml", "-o", "output.tf"
    assert_equal expected, File.read("output.tf")

    assert_match version.to_s, shell_output(bin/"tfk8s --version")
  end
end
