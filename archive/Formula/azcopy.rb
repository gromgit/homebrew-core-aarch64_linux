class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.14.1.tar.gz"
  sha256 "7fdf462e89c7c2ffa6d093a49cd2bf54457864856442dc81607212e4e0f88548"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/azcopy"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9576de2e2a9c837aa39421e2800ee679d99b7ca0a25c5f60f1aa3ab90d093ceb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
