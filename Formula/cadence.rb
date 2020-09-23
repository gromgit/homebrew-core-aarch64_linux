class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.9.0.tar.gz"
  sha256 "f1ad1d28d2a981fa97c5333f8432fa479a89a6b27da8f2b436c1f5c339b1bd86"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f1978c023595bc2babb8111082acc3c27ab0e19b3caac9b94fc07741d94d6c1" => :catalina
    sha256 "4d08001042941ef5d39687925ab511009d8e18f6a5021ce08cf5fa643125a27d" => :mojave
    sha256 "7b1baa8983fde8930175abf7e077d0c3859afffea84fdd54fba40ab06074cb97" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
