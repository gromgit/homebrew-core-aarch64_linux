class Tendermint < Formula
  desc "BFT state machine replication for applications in any programming languages"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.34.0.tar.gz"
  sha256 "3a28fac4c5e610fc32763db1b717ec0a1e12d39262e321d6da223c3b0acfea7f"
  license "Apache-2.0"
  head "https://github.com/tendermint/tendermint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad7854f901ae4ac1ab4f7af7f02d4ee00d807789914515fd25b1c5b2c8c2ca04" => :big_sur
    sha256 "3901a4b32d2fd8c576929b52603c2166f08978a228f8c18491b258c72f0777e9" => :catalina
    sha256 "65a04941f0c97cdb98ffdf3b4e16fe4640566d35b107b634bcd789779fa58deb" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "build/tendermint"
  end

  test do
    mkdir(testpath/"staging")
    shell_output("#{bin}/tendermint init --home #{testpath}/staging")
    assert_true File.exist?(testpath/"staging/config/genesis.json")
    assert_true File.exist?(testpath/"staging/config/config.toml")
    assert_true Dir.exist?(testpath/"staging/data")
  end
end
