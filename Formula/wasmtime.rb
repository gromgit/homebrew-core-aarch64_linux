class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.38.0",
      revision: "99c6463abd69aa02a34f40da7eaebfc9b30f1feb"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e9ee3796744adc6c3b0d7a859cbfdb97c75f00dd5fb97aaa9ab2691f64ba0da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a51636fbf60dcdb59df6fa7ef1efce3b8fedd4452d706324cc2c2f537e775f4"
    sha256 cellar: :any_skip_relocation, monterey:       "684ac23257c1f65ec510f43cc37f88a531ce84515cbe352664a9ddd588a85a41"
    sha256 cellar: :any_skip_relocation, big_sur:        "acbac7bfa1ab384774372b6d6430cf05cde995177d36616a781a20e1315b3e6a"
    sha256 cellar: :any_skip_relocation, catalina:       "9fb1cc6cd40e845547a1ff33c879e63afadc3c326ee89b5dcd6c1178c3badc57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b3bbf077893338f17d347f67b43e8c527eae4cecb9e20bebecdb12e37efb29b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime #{testpath/"sum.wasm"} --invoke sum 1 2")
  end
end
