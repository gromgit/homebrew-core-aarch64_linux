class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.4.1.tar.gz"
  sha256 "a83f4d46a189f1e8803acd96596662deab4ed8903130ef6dc8637c195cf51319"

  bottle do
    cellar :any_skip_relocation
    sha256 "2516fca04d2b6a551b9a474fe721e6bb76e51e306abbb565871c37d5353e654d" => :catalina
    sha256 "611e60817a4e0be00bda6c1fca60d519942cc84fbb955df5a4784e8c565815b3" => :mojave
    sha256 "5aec253fedad3fc8489b1d83530d54c28ba16a751651ba3d974201020d53cae2" => :high_sierra
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
