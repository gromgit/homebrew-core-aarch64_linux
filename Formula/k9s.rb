class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.9",
      revision: "313e6c9749f5ded27637a1c6a8ef086e51b9014a"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e638c2f26a4dcb4382d0161cea622b8436cd05677dfe631b4636f1292a45247b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6bcf22c7fb499b805ec6d9d301d8ee2151073f75fad189281b3ce5614cba9be"
    sha256 cellar: :any_skip_relocation, catalina:      "76a4796d5d95ae0f0a1fdd107a0e53ce5981c7504d56777d3b7c0b8d993ff783"
    sha256 cellar: :any_skip_relocation, mojave:        "24291312482f7b02538876f8aa708d14256245928e234e667ab9ddd21eba2267"
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
