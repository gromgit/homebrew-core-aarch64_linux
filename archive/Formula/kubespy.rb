class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/v0.6.0.tar.gz"
  sha256 "ff8f54a2a495d8ebb57242989238a96c2c07d26601c382a25419498170fc3351"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kubespy"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "434f59254f28cff7f9cf13fba0435eacf8051634760cd3e2b2931984b9d1840e"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/pulumi/kubespy/version.Version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "Unable to read kubectl config", shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
