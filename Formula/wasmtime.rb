class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.36.0",
      revision: "c0e58a1e1c22b53e0330829057da6125da89bef1"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "265c7f8e701ae00d5b2cf505c4912f9822e6d59c3c7809d9f6dad6367f6bdac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed15f7f03e2f3e76a6d6842e28869571e75852461bc4508b37c522292d301eaa"
    sha256 cellar: :any_skip_relocation, monterey:       "d0e3006e0051b3814b87286140218b5a5f2cebcd4fa71599e119fca2efadecf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f679e34038caf75467796dc7356adc0368f73738b5239aac8f989bd0d4131eac"
    sha256 cellar: :any_skip_relocation, catalina:       "288fe978988003a5022ea4bfd55e15d493d1788064ad7aae0fb452744ccc88d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ac615b3ab6b5ec1fa059af27dee8fbe6995503a3fdf209bd5ae123cc25ca50"
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
