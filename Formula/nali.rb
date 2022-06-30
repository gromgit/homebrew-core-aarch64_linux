class Nali < Formula
  desc "Tool for querying IP geographic information and CDN provider"
  homepage "https://github.com/zu1k/nali"
  url "https://github.com/zu1k/nali/archive/v0.4.6.tar.gz"
  sha256 "aca97314107e38a4d8b87fa497c1e36c6bd15f7eff04c288c7dddd85aedd25a0"
  license "MIT"
  head "https://github.com/zu1k/nali.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6152580c691e8ec6f6c332c981aa4bf1b2f6847311f5aa81701a44de3ac00c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33964ff79d6db8ac9b7b257af1c11e91b6ecaef1f291689610227d5c24924d9f"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a3c972df845f1216daaf22d87c5834c002f86fec6cc6fecc573178f6fc7499"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d04250b8cb97bea4f7f7bcbc8c8d2a56709f1938ef4bb576fc04e05746a597"
    sha256 cellar: :any_skip_relocation, catalina:       "0ae35883d9021a06f66ab39dc9fcf8f5721ba35a5c66e5745d7700bfaef4bd10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f0783decc4b87c53f50faba81e68726850f1038891febc4735c5563448cbad6"
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
