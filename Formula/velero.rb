class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.9.2.tar.gz"
  sha256 "ad910f18ad4a5e7d5c5c21e7d631885e109f49d9c03553628a4592998c54408e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc6a8a6356d3c1d3461c623fc6b6e18b68f738440b039a327c700218a9a8810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01fbfe905cbf47d056de89346dc486b9229ec929cdb1a8a2f1e100fddadcb8e3"
    sha256 cellar: :any_skip_relocation, monterey:       "3be6d81159876050b7f83718968d24946a492caecc0900dd541c98edfbd854e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "949012a43992cfde3a2273cbfdefdb18ec13c68dcbf62d24195c7c0d56fcb63c"
    sha256 cellar: :any_skip_relocation, catalina:       "74890025164a0e62dc87f99e18de8d43c5a1c93dad8294f9930d7e754b4f2cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce55c308a2a22611139e0d49c857a953d2a818584521f0ec964b76fb6c88f77a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", "./cmd/velero"

    generate_completions_from_executable(bin/"velero", "completion")
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
