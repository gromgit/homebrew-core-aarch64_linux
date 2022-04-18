class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.25.1.tar.gz"
  sha256 "d3c65e67cabae0c1ac4f5607baf4495f5197f74ad3e1060ee108f1d267509c70"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6409c8aa1fc386b82810521e57bb01dcc5d18cfaa0bbeb7352072a2a4813ab16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dca57b31cd3d24851789bf400c708c8f85469b0f960c6a3945eaa6ddcd0ff91b"
    sha256 cellar: :any_skip_relocation, monterey:       "eeb95aa5402b3f1af2740d52f03526ffec9c1dea439ad7d20e59aef6c80a6f28"
    sha256 cellar: :any_skip_relocation, big_sur:        "b90ff905d9928fdbba8aa1613c7917aaffa4e882359367f70cfa9952f3134198"
    sha256 cellar: :any_skip_relocation, catalina:       "7123eaf0c56f5b0941425c26a853d29cbe97b817d981cc84787be2ccb4c0ddf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a0001b173a24ca05d5185016569ff3dab53ec2dce8f36a68147c7cb705f8df"
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
