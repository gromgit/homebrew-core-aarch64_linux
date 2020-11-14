class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.23.10",
      revision: "a952806ebaa316e2c7d0949ad605fb4c944f2cd0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfa14ecb2f6f551fd27aa711f726ca63adea703586e12471939c0532e71edd4a" => :big_sur
    sha256 "1221af992cb95a512f9e749462c41f174f01fd7bde86fd6f18797f70e17a0e9a" => :catalina
    sha256 "ff4bb8ba72cae9b95ebf1a09a0eb5cf3a3d78786f7370c2d115027971f4b2902" => :mojave
    sha256 "82609c06825c9b1228487f55a8a5628cb19a3f538f95b82aa000fc0e1d0a9190" => :high_sierra
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
