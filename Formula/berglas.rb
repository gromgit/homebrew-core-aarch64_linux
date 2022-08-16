class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v1.0.0.tar.gz"
  sha256 "634238a2793867a5b8c209617a025fe19002a88b53cb54eef45fc2b9c0fcc55a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a02405042b886a81392158073896fdfcfa0ae3de3df9e1de17852ab7b406818b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49b97ed43bb8ecde406539d3062b0422f1652a05c1f46807a673cff11dd9bd94"
    sha256 cellar: :any_skip_relocation, monterey:       "10892bd4fd4b8ba1159820fa14c0e735ee5bb11d5953ebadc8c9770c2cee9082"
    sha256 cellar: :any_skip_relocation, big_sur:        "59a3884fc2f2613011e4a1b181fe57da26afdbbafc053524ca36e0e20f04e789"
    sha256 cellar: :any_skip_relocation, catalina:       "b99a9561cc1880f5b3fe509d6101c12e269ee43a1b74596a23408f2b2a7099e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ec8a9d2c7c387c2b7e28ae23f4d2b6d432dbac824c9e0abfb4a56d00fade8a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
