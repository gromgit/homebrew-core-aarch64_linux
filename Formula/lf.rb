class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r27.tar.gz"
  sha256 "cdd132e33387423ef9f9448e21d3f1e5c9a5319b34fdfb53cb5f49351ebac005"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lf"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e03a85def54839b2264b69f754b26603de044f619f71d28b90d1add0dab8aaa7"
  end

  # Bump to 1.18 on the next release.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
