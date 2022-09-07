class Goctl < Formula
  desc "Generates server-side and client-side code for web and RPC services"
  homepage "https://go-zero.dev"
  url "https://github.com/zeromicro/go-zero/archive/refs/tags/tools/goctl/v1.4.1.tar.gz"
  sha256 "019cbb71d900903656282e448fca8ffa45b6288a3f50e7295b5a4cd68ab0a3f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2726d8c3ea6008c34c4658f5a7184de4ec5420116ac977f1d4c2cc4b291add0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aecbbb63fda44f7492c25e75b1e2bb22d5c8ba3bd280fcfcf2c26d9fa08ee3ae"
    sha256 cellar: :any_skip_relocation, monterey:       "32b3ac2acbe5a023b8ff400e78c192bc02bc97bac7b7ad378f1512a3136fb75a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad9cf6866ac8044d62dbd226396693eb3e580dc88ffaf5dd488c467b842b4717"
    sha256 cellar: :any_skip_relocation, catalina:       "71735e1594d139772597197608a8f73bb5a814bd2108d2e354f46c7ab7cd640a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb81d7604233432f5e6cb1d6b9beed4ca0103402e4ab6df83a3ff9ad1aaf8f76"
  end

  depends_on "go" => :build

  def install
    chdir "tools/goctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"goctl"), "goctl.go"
    end

    generate_completions_from_executable(bin/"goctl", "completion")
  end

  test do
    assert_match "goctl version #{version}", shell_output("#{bin}/goctl --version")
    system bin/"goctl", "template", "init", "--home=#{testpath}/goctl-tpl-#{version}"
    assert_predicate testpath/"goctl-tpl-#{version}", :exist?, "goctl install fail"
  end
end
