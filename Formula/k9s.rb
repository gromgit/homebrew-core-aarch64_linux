class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      :tag      => "v0.21.3",
      :revision => "251221c19b182089c61f8562dc5a024a38e440ee"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "713ce4d49670c5ee47425bed9b9437d3d5fa47ad84691a38e9cdc5f73364aa7b" => :catalina
    sha256 "71dc6a54bf42b169d4f1001a30fd07008ccd82907101b906af9c9c74eb8b64c1" => :mojave
    sha256 "d6f54aab8f27a08e4d640e7180e42aa070816b15e82a51e13e6e4d6942fdeab2" => :high_sierra
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
