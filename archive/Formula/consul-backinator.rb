class ConsulBackinator < Formula
  desc "Consul backup and restoration application"
  homepage "https://github.com/myENA/consul-backinator"
  url "https://github.com/myENA/consul-backinator/archive/v1.6.6.tar.gz"
  sha256 "b668801ca648ecf888687d7aa69d84c3f2c862f31b92076c443fdea77c984c58"
  license "MPL-2.0"
  head "https://github.com/myENA/consul-backinator.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/consul-backinator"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cd0841b6b2e4c7f614cc8f28f2b7c51fe09c091608134578e7ddcb192b47553c"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.appVersion=#{version}")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/consul-backinator --version 2>&1").strip

    assert_match "[Error] Failed to backup key data:",
      shell_output("#{bin}/consul-backinator backup 2>&1", 1)
  end
end
