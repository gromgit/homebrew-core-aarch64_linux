class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.4.0.tar.gz"
  sha256 "14ace836568146745f4d6117329ca2154d1168f783e104596694dcb59491b7c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "df62936f47c29c0a733acf562428fb45d77b12a2ae450814a1d0e4862d1db2d9" => :catalina
    sha256 "403e5ee79c524eda923247880087c9e9feebc0bb9c3e5697da45e60948e566ad" => :mojave
    sha256 "e25187299dd50b517815cccab2ba79af504e2795fdb9d7f9519b0c97b3c1aba4" => :high_sierra
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
