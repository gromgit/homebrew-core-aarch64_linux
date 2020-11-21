class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.0",
      revision: "752869c937fd5f1875ae0718255124644ad40e01"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7f7810f7a48886bb322266cd57e4a663f5564944e53dcff2963227126d0519b" => :big_sur
    sha256 "40afb1ad9152bbc6c7b6624e63e922ddb2e1053518f46bb284ba0afcc6057d2f" => :catalina
    sha256 "709db3ee19dc3cf68350de020c9d179a3631f7cb561cf75af3a8195e78db35cd" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X github.com/derailed/k9s/cmd.version=#{version}
             -X github.com/derailed/k9s/cmd.commit=#{stable.specs[:revision]}",
             *std_go_args
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
