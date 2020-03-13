class Wasmer < Formula
  desc "🚀 The Universal WebAssembly Runtime"
  homepage "https://wasmer.io"
  url "https://github.com/wasmerio/wasmer/archive/0.16.0.tar.gz"
  sha256 "1adc0ad517f7bbb7c4b111fc06e2d6a019d336448b943c56f2ab257a8066464b"
  head "https://github.com/wasmerio/wasmer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "391dec3e05dd8fdd8d5dbe602b6a2a9186abcb024bf3f581e83bb5b235c5333a" => :catalina
    sha256 "cf6118fee3b8247c3e55b885a4b0eff21d256d663cfe09ca9682b66e3a0f6dd6" => :mojave
    sha256 "bf72871eacaf031eca8d0508b462ddb4209f482f2a3570eeb0c9eeab50833b37" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "wabt" => :build

  def install
    system "cargo", "install", "--locked",
                               "--root", prefix,
                               "--path", "."
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "sum([I32(1), I32(2)]) returned [I32(3)]\n",
      shell_output("#{bin}/wasmer run #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
