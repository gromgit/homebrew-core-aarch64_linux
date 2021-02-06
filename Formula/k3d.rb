class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v4.1.1.tar.gz"
  sha256 "17ac775eb6d20ad63104962d0b34036fd4251feef5309cf8e9ae642748a7b7ec"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88dc81dc37746ca7a557528f63d6fed8d4311d6e67a3286a15a4a9b174579479"
    sha256 cellar: :any_skip_relocation, big_sur:       "f66603add4aad6c75876ab316b60372eca3b14935c9a53f6b410f87d56694c23"
    sha256 cellar: :any_skip_relocation, catalina:      "844eec296826a293b089aaa0c7d6903bae546c4e2fc58aca8ae7b849fddf8a3b"
    sha256 cellar: :any_skip_relocation, mojave:        "7073106598763da966b3c734dd74a20ac40aafa83d38b1c59915b114832a4ae4"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
           "-mod", "vendor",
           "-ldflags", "-s -w -X github.com/rancher/k3d/v#{version.major}/version.Version=v#{version}"\
           " -X github.com/rancher/k3d/v#{version.major}/version.K3sVersion=latest",
           "-trimpath", "-o", bin/"k3d"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "bash")
    (bash_completion/"k3d").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "zsh")
    (zsh_completion/"_k3d").write output
  end

  test do
    assert_match "k3d version v#{version}\nk3s version latest (default)", shell_output("#{bin}/k3d --version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match "No nodes found for given cluster", output
  end
end
