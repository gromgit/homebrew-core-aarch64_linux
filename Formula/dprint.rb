class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.16.3.tar.gz"
  sha256 "06ecc241cf521372c59fd2f8f235ae2ddf6d7d1b9c451035149cc6e6d015fe4f"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cefd07b3ce15b9871602ed580d217faea7ed8f4c8f72e8bda50447e6d1438890"
    sha256 cellar: :any_skip_relocation, big_sur:       "f4968e791594d0b63eaadcda03e5b84361a248b3104e17a0bbff1733c758991d"
    sha256 cellar: :any_skip_relocation, catalina:      "7ffe57fbf0adec12f68e765916a0aaaa0a31fd3d030493f5d3802bce2f4d3670"
    sha256 cellar: :any_skip_relocation, mojave:        "d074693c790e5528d33a723625b6c20708e772401ecebc6e38c24513e8ed1843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d8478e69a908f053f38c4ef39b8969e36cd4937a6b3db6c2e710429a9e2fbbf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
