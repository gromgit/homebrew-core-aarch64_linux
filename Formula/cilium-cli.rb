class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "50cc6d9238f03f560c038a61e10d92c88f8e70a290fed85b0237d1cf9c57e74a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cc3874ad087406fae0a1cba7f819673893e3e886c22e20da270dd840960ce60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "297be2929cd91e2aa4f10f7ac7115de2ca8bb7267d33e926b26856a6a6075e12"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a6d3ce9b46a5b478cb9c2d6d9abab7eac845138ce12e9649d53bba538d1ce5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a039500c0145df0984371c38fe22b0ad41e37d1bfe0824f4404447d1d9344d95"
    sha256 cellar: :any_skip_relocation, catalina:       "4266832f38fc59c6eafdeaf062513f28ac73d0ad5e54079fd4f2a122cc260545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2608178b56ce0f92f643560b36673ddffb899970d1521588b34ffc38ed4c57b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    bash_output = Utils.safe_popen_read(bin/"cilium", "completion", "bash")
    (bash_completion/"cilium").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"cilium", "completion", "zsh")
    (zsh_completion/"_cilium").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"cilium", "completion", "fish")
    (fish_completion/"cilium.fish").write fish_output
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
