class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.25.6",
      revision: "f0b540a350b44009b06159d7cb519f612990431a"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baad0b8ddf5ac25f98adc2eff461920c2935de461bb193b6fb9d95b9e4e256a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5248872ea9a5edac3a2ae891f988d1af0ecb176f433a817707be51236d762a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "8138e958dacda14fa9ac8e8c975cad88731c73d6ae8b5668d7ffb5414952b38a"
    sha256 cellar: :any_skip_relocation, big_sur:        "24e8d008edc07e6fe06462a8a064de653f4798fec1a012add21c7b1be03812f0"
    sha256 cellar: :any_skip_relocation, catalina:       "f3d942739098b894dc38bc55604e2c91ebcaa3063b0bd30a257b11667987699b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28548df21da18ca36af328de0505b0a9498c44f14b13b89828af4008b6c8056"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args

    bash_output = Utils.safe_popen_read(bin/"k9s", "completion", "bash")
    (bash_completion/"k9s").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"k9s", "completion", "zsh")
    (zsh_completion/"_k9s").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"k9s", "completion", "fish")
    (fish_completion/"k9s.fish").write fish_output
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
