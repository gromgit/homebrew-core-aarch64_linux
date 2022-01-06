class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v0.33.0",
      revision: "8043c1f919a77905255eded33e4e51a6fbfd1de1"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ba951e4d921e2a1b4ef94d97fea43692f25ca733ff93b2d69d3cded2b76d65e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77b879467406c9b6c820259024b86d8a514fc8fad834175b9f21e3013a550ea9"
    sha256 cellar: :any_skip_relocation, monterey:       "02b6f2017c65d16ec6ed268acd3ec2bd2ce1f2404ef64a2bc02815800828fd28"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb07bb6936633549874ca92a8108ea1eb0529b1a6160dd22f0b3e2b214677de5"
    sha256 cellar: :any_skip_relocation, catalina:       "cd4ec75f230c2adaefc4d5c3067c3b113102755f01d51c71c0aa8b02a3cda777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca133ecd5f9e240f0923e9a9e53eb5e580ed7bc67e705b857ccfb7453356e8b5"
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
