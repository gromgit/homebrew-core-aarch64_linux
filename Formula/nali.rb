class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.4.2.tar.gz"
  sha256 "25842823d61b1c05d8e261c28a2f24232838a1397cbe3b227a2c6288ec451fd6"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nali"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "677eba9285df50e090d748058a82534cd45d4e8fee1641249c07a0e94c67b8b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    (bash_completion/"nali").write Utils.safe_popen_read(bin/"nali", "completion", "bash")
    (fish_completion/"nali.fish").write Utils.safe_popen_read(bin/"nali", "completion", "fish")
    (zsh_completion/"_nali").write Utils.safe_popen_read(bin/"nali", "completion", "zsh")
  end

  test do
    ip = "1.1.1.1"
    # Default database used by program is in Chinese, while downloading an English one
    # requires an third-party account.
    # This example reads "US APNIC&CloudFlare Public DNS Server".
    assert_match "#{ip} [美国 APNIC&CloudFlare公共DNS服务器]", shell_output("#{bin}/nali #{ip}")
  end
end
