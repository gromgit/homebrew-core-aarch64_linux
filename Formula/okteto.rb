class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.2.2.tar.gz"
  sha256 "d11fe64407335c67d402ee9ff323465e5c5727e8b7261255540b464f7c70c241"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb6687a5abd5d544b6c00766a3bc1840773774cc9c020e687bd69975a9dc8b44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "babfa5824fa8e7b416b4805a43309da1396056286cfe1200bdee1fc070a12cc1"
    sha256 cellar: :any_skip_relocation, monterey:       "3e6a63ff7819df68a1e8c91c476bc93a1f3aa3e5c4481e879146cfbb8ac8289c"
    sha256 cellar: :any_skip_relocation, big_sur:        "24d00ce13cdb7d576d4080bdb7fd9275ff7e510eff2166d4e83364a45da4d1df"
    sha256 cellar: :any_skip_relocation, catalina:       "a7688861a411524b7affbf46bbfb45af10b5e133f61108609c606b94a960651f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5eceae8769bf8f8992de9ab92b1043a0491a19ac320e1702ae16037d3bdb7a6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    bash_output = Utils.safe_popen_read(bin/"okteto", "completion", "bash")
    (bash_completion/"okteto").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"okteto", "completion", "zsh")
    (zsh_completion/"_okteto").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"okteto", "completion", "fish")
    (fish_completion/"okteto.fish").write fish_output
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
