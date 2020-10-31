class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.23.3",
      revision: "0fc7ea318341a0033d4639bb627bc359aed370b7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2dbf29f4c204cb5358708435e0ab2baacc667b854fc85056daad64ef4405a898" => :catalina
    sha256 "f53502be87dc3371407b68840d42df2e6792205f64fec073f4ed7a4567d369d9" => :mojave
    sha256 "94c8995976d54b16ab2da8ae9496eb25eb4c6a9dcd6b2cfa36e55355bd068c2c" => :high_sierra
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
