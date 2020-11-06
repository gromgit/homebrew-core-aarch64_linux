class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.23.7",
      revision: "a6f950b2a293423c685928dc9a0d8fa1ac195db3"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5960f568bb72d850577fa99c526e63d6f9e56ade36c3cdc8169a74fa4ce37a4e" => :catalina
    sha256 "bedba91dd41c240f3165f24ac90404752d7d2fed575d419d0abccdbe70061a45" => :mojave
    sha256 "93ab3a074cdb609d6d25470116cb7d1e41bf514aae17712b7fc6251d5d7fe6ff" => :high_sierra
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
