class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.40.0",
      revision: "3615f9497dba54aa9137d4ee4e989054749a0d10"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0301c3aa2d12e9638e66ad914827d2229c7c6379c2b4a61ca5f18101a2f3492c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "decf6026bad7b05c4bb4b8801da1533521b99f2a6c36cf40cc522d3ffbb3b17c"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5927ec906a84b5d1f5d00ac8b9b188472cdde3fd2388569361bef24d6c3cb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9462824006de2ed8e8f83998813e7d07432143acc4c63c81dc417676ef23b455"
    sha256 cellar: :any_skip_relocation, catalina:       "fc5046f92fd324739804969f7f0017ede0733b09ecd6d3767842fa71274deda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d5b06f996427deb3d4addc157c51255924c6ea1fe7c8e5d95636b532a2e4f7"
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
