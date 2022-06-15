class Nerdctl < Formula
  desc "ContaiNERD CTL - Docker-compatible CLI for containerd"
  homepage "https://github.com/containerd/nerdctl"
  url "https://github.com/containerd/nerdctl/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "ef88445bc3fee6b05668ac1346812b3662ca3542e954234f54ce651b35b1a450"
  license "Apache-2.0"
  head "https://github.com/containerd/nerdctl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nerdctl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "47cb5602ad2b5357613e16427f7bbd90a1accb53083952eb67bb3412c375f5c4"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/containerd/nerdctl/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/nerdctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nerdctl --version")
    output = shell_output("XDG_RUNTIME_DIR=/dev/null #{bin}/nerdctl images 2>&1", 1).strip
    cleaned = output.gsub(/\e\[([;\d]+)?m/, "") # Remove colors from output
    assert_match(/^time=.* level=fatal msg="rootless containerd not running.*/m, cleaned)
  end
end
