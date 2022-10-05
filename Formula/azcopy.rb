class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://github.com/Azure/azure-storage-azcopy/archive/v10.16.1.tar.gz"
  sha256 "16ea52f67ac9778fe5b85eed35eac2b5e748ae1a7f3c736e3cdca9e6aeb6fe3c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4f6d92cbaff731405d89d863c6dca5de89bfc77853f3033e5764e660dc61253"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99ba6afccb6bbd69c3973f22b886d987cade5eab022549333f5429af734a04b5"
    sha256 cellar: :any_skip_relocation, monterey:       "b03eb189fd0b111d91790df8182b1e191daa2ea557651113703bc5734dfdaf71"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d2eede8cdf87b122279873094fbf1e4fd43b2e15df35ecba203d1e9a8f6bc8e"
    sha256 cellar: :any_skip_relocation, catalina:       "b92d49647d701f601899d2f50264848b37f329671f0c1e051c740fd2d585c556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a3c7226404481df5784a0c533632b456895ba9b2ec4f557020353527345151"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"azcopy", "completion")
  end

  test do
    assert_match "failed to obtain credential info",
                 shell_output("#{bin}/azcopy list https://storageaccountname.blob.core.windows.net/containername/", 1)
  end
end
