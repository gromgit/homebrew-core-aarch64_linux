class K3d < Formula
  desc "Little helper to run Rancher Lab's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/rancher/k3d/archive/v5.0.3.tar.gz"
  sha256 "85fff692fd3180fb9d050a0e25a99718cde7539e53ef0ffcb433fd19dd56061f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e68928ecd87209353cf056d69e8ff87cf51832bb69b5acbc33816419e7f747c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a820c0780c654f8abd1bece0f0535c9ca971fbc0c447750dc32980033013e42"
    sha256 cellar: :any_skip_relocation, monterey:       "c3ee237e7a217478b327efb039abbad9f1d80dbd4649f4fd7d2623cd594540ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4d6ddbd63d367da00030548fce3e569193a10d9b350e76835c235184122f416"
    sha256 cellar: :any_skip_relocation, catalina:       "dbed08d2abfe901bc67c50c34aeff8cc482f4768320da3d8f2be55f948f07752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c313a8042ec7b2466a2fff107a71efb3166d1bd5d78406623ccf3a52e4ae06"
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

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/k3d", "completion", "fish")
    (fish_completion/"k3d.fish").write output
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
