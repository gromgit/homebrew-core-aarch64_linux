class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.5.1.tar.gz"
  sha256 "e49bbd017f5d559756537d96c4322d86499c1d24eecceacb65f4ccafe26adbad"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5f16f4a9c8903d5dd834c5e7e2643d2c62df77e95beccebac5da88aa9ba2c557" => :big_sur
    sha256 "e2bcbc1cc91e34c4d552e1302dcb0aaaa61d2533bf2b4a807ea55d432075df47" => :arm64_big_sur
    sha256 "69357caf41b473b9131bfe7ba0b434de75cf1accacc3565b0c3ee143f8608cd1" => :catalina
    sha256 "72f74f454bc6f1d1306c8f044dc8545aeee5d44610f9e15c95239852b51d922d" => :mojave
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=0.0.0-dev", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=0.0.0-dev", output
  end
end
