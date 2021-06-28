class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.11",
      revision: "9b498196f908ef2ceb4b02b065818485e8efe19f"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bde0a9ca13d5614255d5ea5a407c1bded69a3e1375ead316d89c35895c5c05d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "ecb2b6ae4462fc59ac690483874709d887b50a97bb6905cc10c08739f891b0a9"
    sha256 cellar: :any_skip_relocation, catalina:      "18184e5fb80e9fe2e679ec64054c94bcf8f50890b93f59176eef00577c22994d"
    sha256 cellar: :any_skip_relocation, mojave:        "f6d912ab32708376302444557c5f7f07c6ee9b8b414865d445908e546a384e91"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
