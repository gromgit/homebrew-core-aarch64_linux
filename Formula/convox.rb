class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.23.tar.gz"
  sha256 "3833abb13ae7e7e6bff224f5721e598907032e8b5c66c8f208a56f26d14c41eb"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "9ed3384832d3d98805443b5611a7ce5d0c06a766247c25b6d4a24f3455217708" => :catalina
    sha256 "3d26506312f0e517a0f0ce3c93477017c53427fc79084e628499887544fcc921" => :mojave
    sha256 "f8759c5f2e96c8ef61081875ad82eee7eb350dd30582058d9eadaf6097754fee" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags=-X main.version=#{version}",
            "-o", bin/"convox", "-v", "./cmd/convox"
    prefix.install_metafiles
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
