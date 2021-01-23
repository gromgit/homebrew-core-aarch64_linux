class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.5.tar.gz"
  sha256 "610d9c2951b0b2f7d1f9a6904daa48b74744561c0f132e9262f2c63ca72ead39"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5970ba02b4132aa30de6e8b241fb974ddee8aa770d381f7dc311d048d1c38da5" => :big_sur
    sha256 "6e26f669f1f32af230be951e01807f7ba7b32064c99f7e506a3e211a0babddc4" => :arm64_big_sur
    sha256 "42436a0f6dff3e394618eaddb5b183ce1e566a7a168e3d3a3d75867b5d72f16f" => :catalina
    sha256 "02bad05c5fde3370a76c7ce2b6f2f237834c98bf8d68c3fef0a4ce27b9312c58" => :mojave
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
