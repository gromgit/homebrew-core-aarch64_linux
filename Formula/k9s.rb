class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      :tag      => "v0.21.4",
      :revision => "f4559a16cca10c8371695ce8e357309f4820f82c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "67f5b73d2dd1e0f6da2ea2932ce76ac788945306255f478aa5ae68b9f77d6464" => :catalina
    sha256 "bd903d59fc332fad40f43858112b70b0976b1eba9fa2bb1325555b63d7ca93e9" => :mojave
    sha256 "2818eb4946a9acf54d9cdcf31a15d429d6b031d0349e8e7657201d4ff61b846f" => :high_sierra
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
