class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.12",
      revision: "a9ede22134ad68e7841b88294fd87328895b4604"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1c312facbde2ef4f286c85f7471a29971277ec0680c8e1446b2b8e603a40058"
    sha256 cellar: :any_skip_relocation, big_sur:       "a0f0ede950b15087ef730c932cde71d82054c611beb47009f94357adb0be0751"
    sha256 cellar: :any_skip_relocation, catalina:      "66755a124552366510e5a43e4a700c5ee7bb6520e5f9bf8157c3548e4af50808"
    sha256 cellar: :any_skip_relocation, mojave:        "9d35562415cb8c8d9761c2a654a8687fcad792916fb9d5ca35b9fb3ce5a668ba"
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
