class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.21.7",
      revision: "cc0e8e88d3d03b57d6251b63cfd3351d3e0d7acd"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "78baa27b60d788fcc5f145bab7c75b6bb8fc5ba3ac427b57c951e0ca0da99a46" => :catalina
    sha256 "1230568dc4d8f32af168f9b2a5cea8c2c85bf8764f7beb6ee3befe952779bc89" => :mojave
    sha256 "446c7da6e3272034b39c05cd8e49116e132b2f5b2c0f3f99be4157f1a368f88c" => :high_sierra
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
