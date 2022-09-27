class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.26.6",
      revision: "c66002d9868fc172e0bb8091ad87d61be027aae2"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f5c6886fc96c0844b1ce214e1841a0fa16bf853b5260e4afbbd8d8cb3bcc316"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f783b8eb009d5a8b0580fb6dcc16dfcd0f0f723910de208e3a167487783ff95"
    sha256 cellar: :any_skip_relocation, monterey:       "af8b3d235793a1cc7307dde63726801d0a48557817bd7775728ee03e077fb9bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4793008d982a0fb704c748d1b342ab2ced8bb4f1bf93fbcbfcc8144f987fcbba"
    sha256 cellar: :any_skip_relocation, catalina:       "af36395465d0d4038feded022d06f0218c08e93a37ac2cf8cf8f9860de6d9ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5f72250766271528001344a74e04325670dc76c8e164a1a3335c1283ec15d7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
