class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.2",
      revision: "f929114ae4679c89ca06b2833d8a0fca5f1ec69d"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11eea882d339e31c60c8e3a18ee1d1f4d139896fabb812d87678a63b6d803be7" => :big_sur
    sha256 "ed3986986c2b2ed043008ec07abf8aec0f9d778ae4a5129cfdbf07e975d6cc15" => :arm64_big_sur
    sha256 "f79446010fd169eb3177e37542116e1197f85010394cca9e146c8088a8cfdab2" => :catalina
    sha256 "975c7f0640f603439df7280e9cd836be0b7fc4dfb27d5c728c8084bf4eea2376" => :mojave
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
