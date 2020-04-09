class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.3.2.tar.gz"
  sha256 "fef550f89340ee02e40aead9285dbce361de8e8c2daa5702a9b4a5b32f236aec"

  bottle do
    cellar :any_skip_relocation
    sha256 "4966b57d66b7d8485bda2597dda2312152b2a0538a279a8a75529d429a7bf8d5" => :catalina
    sha256 "3890637cfa96fb28545846a2826dea5704c0e79b6b5bf4bdc5114d8063806afc" => :mojave
    sha256 "8b1b6d2788c04f3838bceb069e060517bc9f477c89343d19093d431b661915e8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/vmware-tanzu/velero"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "go", "build", "-o", bin/"velero", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}",
                   "./cmd/velero"

      # Install bash completion
      output = Utils.popen_read("#{bin}/velero completion bash")
      (bash_completion/"velero").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/velero completion zsh")
      (zsh_completion/"_velero").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
