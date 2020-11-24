class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.24.1",
      revision: "68981ff5007e9f7031eed1f17e4bc9d406d4d67a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1e47685b2748dddcc0924ce8215962386ac25ba6e56d7ec0ff1fb9e47444ef1" => :big_sur
    sha256 "4fcad77820b4fc48c302f941c218296ac9558dbd5e5357f90d86275377975fee" => :catalina
    sha256 "0e8a88b04b35068e9f7cf94e7029fe3f47331f54a822d8113816ec0010be71f5" => :mojave
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
