class Kubevela < Formula
  desc "Application Platform based on Kubernetes and Open Application Model"
  homepage "https://kubevela.io"
  url "https://github.com/oam-dev/kubevela.git",
      tag:      "v0.2.2",
      revision: "2943bc7ce19c0d6c1f46eecea665760ce3db52e6"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9e8cfd3a05ca4b811a4719e6dcd6a3b7d02f2c0ec0dd92d992c2d260ff07229" => :big_sur
    sha256 "c335351e167f90826a4bff3ce8aa79f438b1901960b6e2f68514e113d62df5b7" => :catalina
    sha256 "dffdc6439bd982fa483eb7826241ac123b5e41e190d7502adca1923a46de42f6" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "vela-cli", "VELA_VERSION=#{version}"
    bin.install "bin/vela"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/vela", "completion", "bash")
    (bash_completion/"vela").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/vela", "completion", "zsh")
    (zsh_completion/"_vela").write output
  end

  test do
    # Should error out as vela up need kubeconfig
    status_output = shell_output("#{bin}/vela up 2>&1", 1)
    assert_match "Error: invalid configuration: no configuration has been provided", status_output
  end
end
