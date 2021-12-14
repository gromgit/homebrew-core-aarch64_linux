class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.32.0",
      revision: "c1c4c59670f45a35ac73910662ab26201e9b6b07"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c08d3333ebc8d27c058193bbd937694ff5fabb6a017ba0d0780990e2eebf02c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "040dda41b2aa678df21b484b4ca2e882bdb32eeb8fe9e03186a91201ef5e4366"
    sha256 cellar: :any_skip_relocation, monterey:       "24bac715becdeb90b74a1ed8e41ce2e2623f94a23f930a49c8a041f6aae6f90b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2855bd8049b3cfa92c2819a3cea1c453c98b85a58458d4f47915f4663a85c02"
    sha256 cellar: :any_skip_relocation, catalina:       "e6c8bf2888525a4310574c8fc64a30a14b1fa587a746d355ad3f7420c871c093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c71343097532d26920958486f085cf264749e049149296f5e83a06f99a6447f"
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
