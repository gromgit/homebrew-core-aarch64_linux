class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.21.5",
      revision: "b67db8c2c8be5fa0b73c215a760cc914dc226b99"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d73f52b2b05a6a4bd97955828bad5e8e4dd1cf79b67f0e496ff5451e0766bb1b" => :catalina
    sha256 "5235f4cacfdc363738b1909bf91a5c1474d84992fbc72810ed361bdf1f7ff43b" => :mojave
    sha256 "821b8d7061ef2d9f895bb634ae6d40b920f32e8d790c5f73cbd2c42a7e005eaa" => :high_sierra
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
